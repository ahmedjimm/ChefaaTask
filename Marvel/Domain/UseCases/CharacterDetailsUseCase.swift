//
//  CharacterDetailsUseCase.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import Foundation
import RxSwift

class CharacterDetailsUseCase {
    
    private let repository: CharacterRepository
    private let characterId: Int
    
    init(repository: CharacterRepository,characterId:Int) {
        self.repository = repository
        self.characterId = characterId
    }
    
    func getCharacterMedia(type:MediaType) -> Observable<ArtWorkCellVM>{
        switch type {
        case .comics:
            getCharacterComics()
        case .series:
            getCharacterSeries()
        case .stories:
            getCharacterStories()
        case .events:
            getCharacterEvents()
        }
    }
    
   private func getCharacterComics() -> Observable<ArtWorkCellVM>{
        repository.getCharacterComics(characterId: characterId)
    }
    
    private func getCharacterSeries() -> Observable<ArtWorkCellVM>{
         repository.getCharacterSeries(characterId: characterId)
     }
    
    private func getCharacterStories() -> Observable<ArtWorkCellVM>{
         repository.getCharacterStories(characterId: characterId)
     }
    
    private func getCharacterEvents() -> Observable<ArtWorkCellVM>{
         repository.getCharacterEvents(characterId: characterId)
     }
    
}
