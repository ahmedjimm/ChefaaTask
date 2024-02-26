//
//  CharacterService.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import Moya

enum CharacterService {
    case characters(page:Int,name:String)
    case characterComics(characterId:Int)
    case characterSeries(characterId:Int)
    case characterStories(characterId:Int)
    case characterEvents(characterId:Int)
}

extension CharacterService: TargetType {
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public/")!
    }
    
    var path: String {
        switch self {
        case .characters:
            return "characters"
        case let .characterComics(characterId):
            return "characters/\(characterId)/comics"
        case let .characterSeries(characterId):
            return "characters/\(characterId)/series"
        case let .characterStories(characterId):
            return "characters/\(characterId)/stories"
        case let .characterEvents(characterId):
            return "characters/\(characterId)/events"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data() // Empty data for now
    }
    
    var task: Task {
        switch self {
        case let .characters(page,name):
            var params = defulteParameters
            params.updateValue(page, forKey: "offset")
            if !name.isEmpty{
                params.updateValue(name, forKey: "nameStartsWith")
            }
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        case .characterComics,.characterSeries,.characterStories,.characterEvents:
            return .requestParameters(parameters: defulteParameters,
                                      encoding: URLEncoding.default)
        }
      
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var defulteParameters: [String: Any]{
        let ts = String(Date().timeIntervalSince1970)
        let hash = (ts + MarvelAPI.privateKey + MarvelAPI.publicKey).md5
        
        let parameters: [String: Any] = [
            "apikey": MarvelAPI.publicKey,
            "ts": ts,
            "hash": hash
        ]
        return parameters
    }
}
