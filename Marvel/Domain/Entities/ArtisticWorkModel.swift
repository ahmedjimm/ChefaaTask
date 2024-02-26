//
//  EventModel.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation

struct ArtisticWorkModel: Codable{
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SummaryModel]?
}
