//
//  CharacterUseCase.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import RxSwift

class CharacterUseCase {
    
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    func getCharacters(page:Int,name:String = "") -> Observable<DataContainerModel<CharacterModel>>{
        repository.getCharacter(page:page,name: name)
    }
    
    
}
