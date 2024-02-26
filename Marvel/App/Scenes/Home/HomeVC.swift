//
//  HomeVC.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: BaseViewController<HomeVM> {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tblView: UITableView!
    
    private let loadingActivity = ActivityIndicator()
    private var searchButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        configureTableView()
        bind()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        tblView.rx.setDelegate(self).disposed(by: disposeBag)
        tblView.registerCellNib(cellClass: CharacterCell.self)
        tblView.tableFooterView = loadingActivity
    }
    
    private func initNavigation(){
        // Add logo to the navigation bar
        let logoImage = UIImage(named: "icn-nav-marvel")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        // Add search button to the right side of the navigation bar
        if let searchImage = UIImage(named: "icn-nav-search"){
            let imageOrignal = searchImage.withRenderingMode(.alwaysOriginal)
            searchButton = UIBarButtonItem(image: imageOrignal, style: .plain, target: self, action: #selector(searchTapped))
            self.navigationItem.rightBarButtonItem = searchButton
        }
    }
    
    @objc func searchTapped(){
        navigationController?.pushViewController(SearchVC(viewModel: HomeVM(useCase: CharacterUseCase(repository: CharactersRepositoryImpl()))), animated: true)
       // self.show(SearchVC(), sender: self.btnSearch)
    }
    
    private func bind(){
        // MARK: - bind Outputs
        bindToLoading()
        bindTblDataSource()
        bindNavigationWithCaracter()
        bindIsLoadingNextPage()
        // MARK: - bind Inputs
        bindViewDidLoad()
        bindTblSelectItem()
        bindTblContentOffset()
    }
    
    private func bindViewDidLoad(){
        viewModel.input.viewDidLoad.onNext(())
    }
    
    private func bindNavigationWithCaracter() {
        // navigate to character details
        viewModel.output.navigateWithCharacter
            .drive(onNext: { [weak self] character in
                guard let self = self , let character = character , let id = character.id else {return}
                self.navigationController?.pushViewController(CharacterDetailsVC(viewModel: CharacterDetailsVM(useCase: CharacterDetailsUseCase(repository: CharactersRepositoryImpl(), characterId: id), character: character)), animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindIsLoadingNextPage(){
        viewModel.output.isLoadingNextPage
            .map { !$0 }
            .drive(loadingActivity.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoading() {
        viewModel.output.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else {return}
                if isLoading {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindTblDataSource() {
        // tbl view data source
        viewModel.output.charactersCellVMs
            .drive(tblView.rx.items(cellIdentifier: "CharacterCell",
                                    cellType: CharacterCell.self)) { index, vm, cell in
                cell.configCell(with: vm)
            }.disposed(by: disposeBag)
    }
    
    private func bindTblSelectItem() {
        // select item in tbl
        tblView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.viewModel.input.tappedCharacterIndex.onNext(indexPath.row)
        }).disposed(by: disposeBag)
    }

    
    private func bindTblContentOffset(){
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
    
}

extension HomeVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
