//
//  ThumbnailModel.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation

struct ThumbnailModel: Codable{
    let path: String?
    let ext: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    
    var url: String? {
          guard let path = path, let ext = ext else { return nil }
          return "\(path).\(ext)"
      }
}
