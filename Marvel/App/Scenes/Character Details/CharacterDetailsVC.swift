//
//  CharacterDetailsVC.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import UIKit
import RxSwift

class CharacterDetailsVC: BaseViewController<CharacterDetailsVM> {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorMedia: UIActivityIndicatorView!
    @IBOutlet weak var viewDiscreption: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var constraintHeightTblRelatedLinkd: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightTblArtWork: NSLayoutConstraint!
    @IBOutlet weak var tblRelatedLinks: UITableView!
    @IBOutlet weak var tblRelatedArtWork: UITableView!
    @IBOutlet weak var lblDiscreption: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCharacter: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bind()
        viewModel.input.viewDidLoad.onNext(())
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        tblRelatedArtWork.rx.setDelegate(self).disposed(by: disposeBag)
        tblRelatedArtWork.registerCellNib(cellClass: ArtWorkCell.self)
        tblRelatedLinks.registerCellNib(cellClass: RelatedLinkCell.self)
        tblRelatedLinks.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bind(){
        // MARK: - bind Outputs
        bindImageCharacter()
        bindNameCharacter()
        bindDiscreption()
        bindHeightTblArtWork()
        bindArtWorkSections()
        bindRelatedLinkSections()
        bindHeightTblRelatedLinks()
        bindMediaIndicator()
        // MARK: - bind Inputs
        bindToBack()
    }
    
    private func bindToBack() {
        btnBack.rx.tap
            .bind {self.navigationController?.popViewController(animated: true)}
            .disposed(by: disposeBag)
    }
    
    private func bindImageCharacter() {
        // image character
        viewModel.output.imgCharacterUrl
            .drive(onNext: { [weak self] imgUrl in
                guard let self = self else {return}
                self.imgCharacter.loadFromUrl(url: imgUrl)
            }).disposed(by: disposeBag)
    }
    
    private func bindNameCharacter() {
        // name
        viewModel.output.name.drive(lblName.rx.text).disposed(by: disposeBag)
    }
    
    private func bindHeightTblArtWork() {
        viewModel.output.heightTblArtWork.drive(constraintHeightTblArtWork.rx.constant).disposed(by: disposeBag)
    }
    
    private func bindHeightTblRelatedLinks(){
        viewModel.output.heightTblRelatedLinks.drive(constraintHeightTblRelatedLinkd.rx.constant).disposed(by: disposeBag)
    }
    
    private func bindMediaIndicator(){
        viewModel.output.isLoadingMedia
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else {return}
                if isLoading {
                    self.indicatorMedia.startAnimating()
                } else {
                    self.indicatorMedia.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindDiscreption() {
        // discreption
        viewModel.output.discreption.drive(lblDiscreption.rx.text).disposed(by: disposeBag)
        viewModel.output.hidenDiscreption.drive(viewDiscreption.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func bindArtWorkSections(){
        viewModel.output.artWorkCellVMs
            .drive(tblRelatedArtWork.rx.items(cellIdentifier: "ArtWorkCell",
                                              cellType: ArtWorkCell.self)) { index, vm, cell in
                cell.configCell(with: vm)
                cell.selectionStyle = .none
                cell.delegate = self
            }.disposed(by: disposeBag)
    }
    
    private func bindRelatedLinkSections(){
        viewModel.output.relatedLinksCellVMs
            .drive(tblRelatedLinks.rx.items(cellIdentifier: "RelatedLinkCell",
                                            cellType: RelatedLinkCell.self)) { index, vm, cell in
                cell.configCell(with: vm)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
    }
}

extension CharacterDetailsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         tableView == tblRelatedLinks ? CGFloat(viewModel.heightRowLink) : CGFloat(viewModel.heightRowArtWork)
    }
}

extension CharacterDetailsVC: ArtWorkCellProtocal{
    func openMediaDetails(currentIndex: Int, mediaData: [MediaModel]) {
        let vc = MediaDetailsVC(viewModel: MediaDetailsVM(mediaData: mediaData, currentIndex: currentIndex))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
