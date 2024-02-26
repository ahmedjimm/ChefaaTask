//
//  CharacterDataContainerModel.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation

struct DataResponseModel<T: Codable>: Codable {
    let data: DataContainerModel<T>
}

struct DataContainerModel<T: Codable>: Codable{
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [T]?
}
