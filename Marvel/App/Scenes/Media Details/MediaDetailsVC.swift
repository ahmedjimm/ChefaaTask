//
//  MediaDetailsVC.swift
//  Marvel
//
//  Created by Ahmed Gamal on 25/02/2024.
//

import UIKit
import FSPagerView

class MediaDetailsVC: BaseViewController<MediaDetailsVM> {
    
    @IBOutlet weak var viewPager: FSPagerView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPager()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.input.viewDidAppear.onNext(())
    }
    
    func initPager(){
        viewPager.dataSource = self
        viewPager.delegate = self
        let nib = UINib(nibName: "MediaDetailsCell", bundle: nil)
        viewPager.register(nib, forCellWithReuseIdentifier: "MediaDetailsCell")
        viewPager.transformer = FSPagerViewTransformer(type: .linear)
        let transform = CGAffineTransform(scaleX: 0.4, y: 1)
        viewPager.itemSize = viewPager.frame.size.applying(transform)
        viewPager.decelerationDistance = FSPagerView.automaticDistance
        viewPager.isInfinite = false
        viewPager.itemSize = CGSize(width: viewPager.bounds.width * 0.8, height: viewPager.bounds.height)
    }
    
    
    private func bind(){
        // MARK: - bind Outputs
        bindToScrollSelectedIndex()
        bindToIndicatorText()
        // MARK: - bind Inputs
        bindToClose()
        bindToViewDidLoad()
    }
    private func bindToViewDidLoad(){
        viewModel.input.viewDidLoad.onNext(())
    }
    
    private func bindToScrollSelectedIndex(){
        viewModel.output.scrollingToIndex
            .drive(onNext: { [weak self] index in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.viewPager.selectItem(at: index, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindToIndicatorText(){
        viewModel.output.textIndicator.drive(lblCount.rx.text).disposed(by: disposeBag)
    }
    
    private func bindToClose(){
        btnBack.rx.tap
            .bind {self.dismiss(animated: true)}
            .disposed(by: disposeBag)
    }
}

extension MediaDetailsVC:FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        viewModel.total
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "MediaDetailsCell", at: index) as! MediaDetailsCell
        cell.configCell(with: viewModel.mediaData[index])
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        viewModel.input.pagerViewWillEndDragging.onNext(targetIndex)
    }
}
