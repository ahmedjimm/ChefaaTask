//
//  ActivityIndicator.swift
//  Marvel
//
//  Created by Ahmed Gamal on 25/02/2024.
//

import Foundation
import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        color = .red
        transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        startAnimating()
        isHidden = true
    }
    
    convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: 50, height: 50))
        color = .red
        transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        startAnimating()
        isHidden = true
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
