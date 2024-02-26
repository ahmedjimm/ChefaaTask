//
//  CharacterDetailsVM.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class CharacterDetailsVM: ViewModel {
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>
    }
    
    // MARK: - Input Private properties
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let imgCharacterUrl: Driver<String>
        let name: Driver<String>
        let discreption: Driver<String>
        let artWorkCellVMs: Driver<[ArtWorkCellVM]>
        let heightTblArtWork: Driver<CGFloat>
        let hidenDiscreption: Driver<Bool>
        let heightTblRelatedLinks: Driver<CGFloat>
        let relatedLinksCellVMs: Driver<[RelatedLinkModel]>
        let isLoadingMedia: Driver<Bool>
    }
    
    
    // MARK: - Output Private properties
    private let imgCharacterUrlSubject = PublishSubject<String>()
    private let nameSubject = PublishSubject<String>()
    private let discreptionSubject = PublishSubject<String>()
    private let artWorkCellVMsSubject = PublishSubject<[ArtWorkCellVM]>()
    private let heightTblArtWorkSubject = PublishSubject<CGFloat>()
    private let hidenDiscreptionSubject = PublishSubject<Bool>()
    private let heightTblRelatedLinksSubject = PublishSubject<CGFloat>()
    private let relatedLinksCellVMsSubject = PublishSubject<[RelatedLinkModel]>()
    private let isLoadingMediaSubject = PublishSubject<Bool>()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var characterDetails: CharacterModel
    private var useCase: CharacterDetailsUseCase
    let heightRowArtWork = 210
    let heightRowLink = 50
    
    // MARK: - Initialization
    init(useCase: CharacterDetailsUseCase,character:CharacterModel) {
        self.characterDetails = character
        self.useCase = useCase
        input = Input(
            viewDidLoad: viewDidLoadSubject.asObserver()
        )
        
        // MARK: outputs drivers
        output = Output(
            imgCharacterUrl: imgCharacterUrlSubject.asDriver(onErrorJustReturn: ""),
            name: nameSubject.asDriver(onErrorJustReturn: ""),
            discreption: discreptionSubject.asDriver(onErrorJustReturn: ""),
            artWorkCellVMs: artWorkCellVMsSubject.asDriver(onErrorJustReturn: []),
            heightTblArtWork: heightTblArtWorkSubject.asDriver(onErrorJustReturn: 0),
            hidenDiscreption: hidenDiscreptionSubject.asDriver(onErrorJustReturn: true),
            heightTblRelatedLinks: heightTblRelatedLinksSubject.asDriver(onErrorJustReturn: 0),
            relatedLinksCellVMs: relatedLinksCellVMsSubject.asDriver(onErrorJustReturn: []),
            isLoadingMedia: isLoadingMediaSubject.asDriver(onErrorJustReturn: false)
        )
        
        viewDidLoadSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setCharacterData()
            }).disposed(by: disposeBag)
    }
    
    private func setCharacterData(){
        setMainData()
       // buildDataForArtWorkSections()
        getMedia()
        buildDataForRelatedLinks()
    }
    
    private func getMedia(){
        let allCases = MediaType.allCases
        var observables: [Observable<ArtWorkCellVM>] = []
        for type in allCases {
            let observable = useCase.getCharacterMedia(type: type)
            observables.append(observable)
        }
        let zipObservable = Observable.zip(observables).materialize()
        isLoadingMediaSubject.onNext(true)
        zipObservable
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                self.isLoadingMediaSubject.onNext(false)
                switch event {
                case let .next(data):
                    self.buildDataForMediaSections(data:data)
                case let .error(error):
                    Logger.log(.error, error)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
    }
    
    
    private func setMainData(){
        imgCharacterUrlSubject.onNext(characterDetails.thumbnail?.url ?? "")
        nameSubject.onNext(characterDetails.name ?? "")
        setDiscreptionData()
    }
    
    private func setDiscreptionData() {
        if let discreption = characterDetails.description, !discreption.isEmpty {
            discreptionSubject.onNext(characterDetails.description ?? "")
        }else{
            hidenDiscreptionSubject.onNext(true)
        }
    }
    
    private func buildDataForMediaSections(data:[ArtWorkCellVM]){
        let sortedData = data.sorted{ $0.type.isHigherThan($1.type)}
        let filterData = sortedData.filter{!$0.Items.isEmpty}
        heightTblArtWorkSubject.onNext(CGFloat(filterData.count * heightRowArtWork))
        artWorkCellVMsSubject.onNext(filterData)
    }
    
    private func buildDataForRelatedLinks(){
        if let links = characterDetails.urls, !links.isEmpty {
            heightTblRelatedLinksSubject.onNext(CGFloat(links.count * heightRowLink))
            relatedLinksCellVMsSubject.onNext(links)
        }else{
            heightTblRelatedLinksSubject.onNext(0)
        }
    }
}
