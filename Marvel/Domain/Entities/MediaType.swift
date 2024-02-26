//
//  MediaType.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import Foundation

enum MediaType: String, CaseIterable, Equatable {
    case comics
    case series
    case stories
    case events
}

extension MediaType {
    func isHigherThan(_ type: MediaType) -> Bool {
        position.rawValue <= type.position.rawValue
    }
}

private extension MediaType {
    enum Position: Int {
        case first
        case secend
        case three
        case four
    }

    var position: Position {
        switch self {
        case .comics: return .first
        case .series: return .secend
        case .stories: return .three
        case .events: return .four
        }
    }
}
