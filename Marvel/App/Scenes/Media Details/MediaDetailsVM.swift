//
//  MediaDetailsVM.swift
//  Marvel
//
//  Created by Ahmed Gamal on 25/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class MediaDetailsVM: ViewModel {
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let viewDidAppear: AnyObserver<Void>
        let pagerViewWillEndDragging: AnyObserver<Int>
    }
    
    // MARK: - Input Private properties
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let viewDidAppearSubject = PublishSubject<Void>()
    private let pagerViewWillEndDraggingSubject = PublishSubject<Int>()
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let textIndicator: Driver<String>
        let scrollingToIndex: Driver<Int>
    }
    
    
    // MARK: - Output Private properties
    private let textIndicatorSubject = PublishSubject<String>()
    private let scrollingToIndexSubject = PublishSubject<Int>()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
     var currentIndex: Int
     var total: Int
     var mediaData: [MediaModel]
    
    // MARK: - Initialization
    init(mediaData: [MediaModel],currentIndex:Int) {
        self.total = mediaData.count
        self.currentIndex = currentIndex
        self.mediaData = mediaData
        
        input = Input(
            viewDidLoad: viewDidLoadSubject.asObserver(),
            viewDidAppear: viewDidAppearSubject.asObserver(),
            pagerViewWillEndDragging: pagerViewWillEndDraggingSubject.asObserver()
        )
        
        // MARK: outputs drivers
        output = Output(
            textIndicator: textIndicatorSubject.asDriver(onErrorJustReturn: ""),
            scrollingToIndex: scrollingToIndexSubject.asDriver(onErrorJustReturn: 0)
        )
        
        viewDidLoadSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setIndicatorText()
            }).disposed(by: disposeBag)
        
        viewDidAppearSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollingToIndexSubject.onNext(self.currentIndex)
            }).disposed(by: disposeBag)
        
        
        pagerViewWillEndDraggingSubject
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.currentIndex = index
                self.setIndicatorText()
            }).disposed(by: disposeBag)
        
    }
    
    private func setIndicatorText(){
        self.textIndicatorSubject.onNext("\(self.currentIndex + 1)/\(self.total)")
    }
}
