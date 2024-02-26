//
//  CharactersRepositoryImpl.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import RxSwift

class CharactersRepositoryImpl: CharacterRepository {
    
    private let remoteCharacterDataSource: RemoteCharacterDataSource
    
    init() {
        remoteCharacterDataSource = RemoteCharacterDataSource()
    }
    
    func getCharacter(page:Int,name: String) -> Observable<DataContainerModel<CharacterModel>> {
        remoteCharacterDataSource.getCharacters(page:page,name: name)
    }
    
    func getCharacterComics(characterId: Int) -> Observable<ArtWorkCellVM> {
        remoteCharacterDataSource.getCharacterComics(characterId: characterId)
    }
    
    func getCharacterSeries(characterId: Int) -> Observable<ArtWorkCellVM> {
        remoteCharacterDataSource.getCharacterSeries(characterId: characterId)
    }
    
    func getCharacterStories(characterId: Int) -> Observable<ArtWorkCellVM> {
        remoteCharacterDataSource.getCharacterStories(characterId: characterId)
    }
    
    func getCharacterEvents(characterId: Int) -> RxSwift.Observable<ArtWorkCellVM> {
        remoteCharacterDataSource.getCharacterEvents(characterId: characterId)
    }
    
    
}
