//
//  String+Extensions.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import CryptoKit

extension Data {
    var md5: Data {
        return Data(Insecure.MD5.hash(data: self))
    }
    
    var hexString: String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension String {
    var md5: String {
        return Data(self.utf8).md5.hexString
    }
}
