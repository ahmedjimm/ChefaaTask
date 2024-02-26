//
//  SearchVC.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import UIKit
import RxSwift

class SearchVC: BaseViewController<HomeVM> {
    
    @IBOutlet weak var lblEmptyReslte: UILabel!
    @IBOutlet weak var ViewEmptyResult: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tblView: UITableView!
    private let loadingActivity = ActivityIndicator()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search For character"
       
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setUpNavigationItem()
        bind()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    private func configureTableView() {
        tblView.rx.setDelegate(self).disposed(by: disposeBag)
        tblView.registerCellNib(cellClass: SearchCell.self)
        tblView.tableFooterView = loadingActivity
    }
    
    func setUpNavigationItem() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchController.searchBar
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
    }
    
    private func bind() {
        bindLoadingIndicator()
        bindSearchBar()
        bindCharacterCells()
        bindItemSelected()
        bindNavigation()
        bindLoadingNextPage()
        bindHidenSearchEmpty()
    }

    private func bindLoadingIndicator() {
        viewModel.output.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.indicator.startAnimating() : self.indicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }

    private func bindSearchBar() {
        searchController.searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .bind(to: viewModel.input.searchTapped)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .filter { $0?.isEmpty ?? true }
            .map { _ in () }
            .bind(to: viewModel.input.searchTextCleared)
            .disposed(by: disposeBag)
    }

    private func bindCharacterCells() {
        viewModel.output.charactersCellVMs
            .drive(tblView.rx.items(cellIdentifier: "SearchCell", cellType: SearchCell.self)) { index, vm, cell in
                cell.configCell(with: vm)
            }
            .disposed(by: disposeBag)
    }

    private func bindItemSelected() {
        tblView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.viewModel.input.tappedCharacterIndex.onNext(indexPath.row)
            })
            .disposed(by: disposeBag)
    }

    private func bindNavigation() {
        viewModel.output.navigateWithCharacter
            .drive(onNext: { [weak self] character in
                guard let self = self, let character = character, let id = character.id else { return }
                let characterDetailsVM = CharacterDetailsVM(useCase: CharacterDetailsUseCase(repository: CharactersRepositoryImpl(), characterId: id), character: character)
                let characterDetailsVC = CharacterDetailsVC(viewModel: characterDetailsVM)
                self.navigationController?.pushViewController(characterDetailsVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindLoadingNextPage() {
        viewModel.output.isLoadingNextPage
            .map { !$0 }
            .drive(loadingActivity.rx.isHidden)
            .disposed(by: disposeBag)
        
        tblView.rx.contentOffset
            .map { [weak self] _ in
                guard let self = self else { return false }
                return self.tblView.isNearBottomEdge()
            }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: viewModel.input.loadNextPage)
            .disposed(by: disposeBag)
    }
    
    private func bindHidenSearchEmpty(){
        viewModel.output.hidenSearchEmpty.drive(ViewEmptyResult.rx.isHidden).disposed(by: disposeBag)
        
    }
}

// MARK: UISearchControllerDelegate

extension SearchVC: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
