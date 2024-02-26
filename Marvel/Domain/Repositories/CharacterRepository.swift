//
//  CharacterRepository.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import RxSwift

protocol CharacterRepository {
    func getCharacter(page:Int,name: String) -> Observable<DataContainerModel<CharacterModel>>
    func getCharacterComics(characterId:Int) -> Observable<ArtWorkCellVM>
    func getCharacterSeries(characterId:Int) -> Observable<ArtWorkCellVM>
    func getCharacterStories(characterId:Int) -> Observable<ArtWorkCellVM>
    func getCharacterEvents(characterId:Int) -> Observable<ArtWorkCellVM>
}
