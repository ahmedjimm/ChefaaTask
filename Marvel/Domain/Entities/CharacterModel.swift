//
//  CharacterModel.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation

struct CharacterModel: Codable{
    let id: Int?
    let name: String?
    let description: String?
    let resourceURI: String?
    let thumbnail: ThumbnailModel?
    let comics: ArtisticWorkModel?
    let stories: ArtisticWorkModel?
    let events: ArtisticWorkModel?
    let series: ArtisticWorkModel?
    let urls: [RelatedLinkModel]?
}
