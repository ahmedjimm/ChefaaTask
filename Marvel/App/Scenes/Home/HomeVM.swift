//
//  HomeVM.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

class HomeVM: ViewModel {
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>
        let tappedCharacterIndex: AnyObserver<Int>
        let loadNextPage: AnyObserver<Void>
        let searchText: AnyObserver<String>
        let searchTapped: AnyObserver<Void>
        let searchTextCleared: AnyObserver<Void>
    }
    
    // MARK: - Input Private properties
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let tappedCharacterIndexSubject = PublishSubject<Int>()
    private let loadNextPageSubject = PublishSubject<Void>()
    private let searchTextSubject = PublishSubject<String>()
    private let searchTappedSubject = PublishSubject<Void>()
    private let searchTextClearedSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let isLoading: Driver<Bool>
        let charactersCellVMs: Driver<[CharacterCellVM]>
        let navigateWithCharacter: Driver<CharacterModel?>
        let isLoadingNextPage: Driver<Bool>
        let hidenSearchEmpty: Driver<Bool>
    }
    
    
    // MARK: - Output Private properties
    private let isLoadingSubject = PublishSubject<Bool>()
    private let charactersCellVMsSubject = PublishSubject<[CharacterCellVM]>()
    private let navigateWithCharacterSubject = PublishSubject<CharacterModel?>()
    private let isLoadingNextPageSubject = PublishSubject<Bool>()
    private let hidenSearchEmptySubject = PublishSubject<Bool>()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let useCase: CharacterUseCase
    private var charactersResult: [CharacterModel] = []
    private var pageNumber = 0
    private var total = 0
    // MARK: - Initialization
    init(useCase: CharacterUseCase) {
        self.useCase = useCase
        
        input = Input(
            viewDidLoad: viewDidLoadSubject.asObserver(),
            tappedCharacterIndex: tappedCharacterIndexSubject.asObserver(),
            loadNextPage: loadNextPageSubject.asObserver(),
            searchText: searchTextSubject.asObserver(),
            searchTapped: searchTappedSubject.asObserver(),
            searchTextCleared: searchTextClearedSubject.asObserver()
        )
        
        // MARK: outputs drivers
        output = Output(
            isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
            charactersCellVMs: charactersCellVMsSubject.asDriver(onErrorJustReturn: []),
            navigateWithCharacter: navigateWithCharacterSubject.asDriver(onErrorJustReturn: nil),
            isLoadingNextPage: isLoadingNextPageSubject.asDriver(onErrorJustReturn: false),
            hidenSearchEmpty: hidenSearchEmptySubject.asDriver(onErrorJustReturn: true)
        )
        setupBindings()
    }
    
    private func setupBindings() {
        bindCharacterLoading()
        bindCharacterSelection()
        bindNextPageLoading()
        bindSearch()
        bindSearchTextClearing()
    }
    
    private func bindCharacterLoading() {
        viewDidLoadSubject
            .startLoadingOn(isLoadingSubject)
            .flatMap { [weak self] _ -> Observable<Event<DataContainerModel<CharacterModel>>> in
                guard let self = self else { return .empty() }
                return self.useCase.getCharacters(page: self.pageNumber).materialize()
            }
            .stopLoadingOn(isLoadingSubject)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .next(model):
                    self.handleLoadingSuccess(model)
                case let .error(error):
                    self.handleCharacterLoadingError(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCharacterSelection() {
        tappedCharacterIndexSubject
            .map { [weak self] index in
                self?.charactersResult[index]
            }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] characterModel in
                self?.navigateWithCharacterSubject.onNext(characterModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNextPageLoading() {
        loadNextPageSubject
            .withLatestFrom(Observable.merge(isLoadingSubject, isLoadingNextPageSubject))
            .filter { !$0 }
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return self.total > self.charactersResult.count
            }
            .do(onNext: { [weak self] _ in
                self?.pageNumber += 1
            })
            .startLoadingOn(isLoadingNextPageSubject)
            .flatMap { [weak self] _ -> Observable<Event<DataContainerModel<CharacterModel>>> in
                guard let self = self else { return .empty() }
                return self.useCase.getCharacters(page: self.pageNumber, name: "").materialize()
            }
            .stopLoadingOn(isLoadingNextPageSubject)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .next(model):
                    self.handleNextPageLoadingSuccess(model)
                case let .error(error):
                    self.handleNextPageLoadingError(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearch() {
        searchTappedSubject
            .do(onNext: { [weak self] in
                guard let self = self else {return}
                self.pageNumber = 0
                self.total = 0
                self.hidenSearchEmptySubject.onNext(true)
            })
            .withLatestFrom(searchTextSubject)
            .filter { !$0.isEmpty }
            .startLoadingOn(isLoadingSubject)
            .flatMap { [weak self] text -> Observable<Event<DataContainerModel<CharacterModel>>> in
                guard let self = self else { return .empty() }
                return self.useCase.getCharacters(page: self.pageNumber, name: text).materialize()
            }
            .stopLoadingOn(isLoadingSubject)
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let model):
                    self.handleLoadingSuccess(model)
                case .error(let error):
                    self.handleSearchError(error)
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindSearchTextClearing() {
        searchTextClearedSubject
            .do(onNext: { [weak self] in
                self?.pageNumber = 0
                self?.total = 0
            })
            .map { [] }
            .bind(to: charactersCellVMsSubject)
            .disposed(by: disposeBag)
    }
    
    // Handle loading success
    private func handleLoadingSuccess(_ model: DataContainerModel<CharacterModel>) {
        total = model.total ?? 0
        charactersResult = model.results ?? []
        hidenSearchEmptySubject.onNext(!charactersResult.isEmpty)
        charactersCellVMsSubject.onNext(buildCharactersCellVMs(characters: charactersResult))
    }
    
    private func handleNextPageLoadingSuccess(_ model: DataContainerModel<CharacterModel>) {
        charactersResult.append(contentsOf: model.results ?? [])
        charactersCellVMsSubject.onNext(buildCharactersCellVMs(characters: charactersResult))
    }
    
    // Handle loading error
    private func handleCharacterLoadingError(_ error: Error) {
        debugPrint("error getting characters info: \(error)")
    }
    
    private func handleNextPageLoadingError(_ error: Error) {
        debugPrint("error loading next page: \(error)")
    }
    
    private func handleSearchError(_ error: Error) {
        Logger.log(.error, error)
    }
    
    private func buildCharactersCellVMs(characters:[CharacterModel]) -> [CharacterCellVM]{
        return characters.map{.init(imgUrl: $0.thumbnail?.url ?? "",
                                    characterName: $0.name ?? "")}
    }
}
