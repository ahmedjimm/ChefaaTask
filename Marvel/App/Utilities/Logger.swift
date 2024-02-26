//
//  Logger.swift
//  Connect
//
//  Created by Kerolles Roshdi on 3/24/21.
//  Copyright © 2021 Expert Apps. All rights reserved.
//

import Foundation

class Logger {
    
    enum LogType: String {
        case ok = "📗"
        case warning = "📙"
        case error = "📕"
        case action = "📘"
    }
    
    static func log(_ type: LogType, _ message: Any...) {
        #if DEBUG
        debugPrint("\(type.rawValue): \(message)")
        #endif
    }
    
}
