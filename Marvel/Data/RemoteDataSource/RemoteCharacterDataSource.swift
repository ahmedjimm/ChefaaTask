//
//  RemoteCharacterDataSource.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class RemoteCharacterDataSource {
    
    private let characterProvider: MoyaProvider<CharacterService>
    
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        self.characterProvider = .init(plugins: [networkLogger])
    }
    
    func getCharacters(page:Int,name:String) -> Observable<DataContainerModel<CharacterModel>> {
        characterProvider.rx
            .request(.characters(page:page,name: name))
            .catchAppError()
            .map(DataResponseModel<CharacterModel>.self)
            .map{$0.data}
            .asObservable()
    }
    
    func getCharacterComics(characterId:Int) -> Observable<ArtWorkCellVM> {
        characterProvider.rx
            .request(.characterComics(characterId: characterId))
            .catchAppError()
            .map(DataResponseModel<MediaModel>.self)
            .map{ArtWorkCellVM(type: .comics, name: "COMICS", Items: $0.data.results ?? [])}
            .asObservable()
    }
    
    func getCharacterSeries(characterId:Int) -> Observable<ArtWorkCellVM> {
        characterProvider.rx
            .request(.characterSeries(characterId: characterId))
            .catchAppError()
            .map(DataResponseModel<MediaModel>.self)
            .map{ArtWorkCellVM(type: .series, name: "SERIES", Items: $0.data.results ?? [])}
            .asObservable()
    }
    
    func getCharacterStories(characterId:Int) -> Observable<ArtWorkCellVM> {
        characterProvider.rx
            .request(.characterStories(characterId: characterId))
            .catchAppError()
            .map(DataResponseModel<MediaModel>.self)
            .map{ArtWorkCellVM(type: .stories, name: "STORIES", Items: $0.data.results ?? [])}
            .asObservable()
    }
    
    func getCharacterEvents(characterId:Int) -> Observable<ArtWorkCellVM> {
        characterProvider.rx
            .request(.characterEvents(characterId: characterId))
            .catchAppError()
            .map(DataResponseModel<MediaModel>.self)
            .map{ArtWorkCellVM(type: .events, name: "EVENTS", Items: $0.data.results ?? [])}
            .asObservable()
    }
}
