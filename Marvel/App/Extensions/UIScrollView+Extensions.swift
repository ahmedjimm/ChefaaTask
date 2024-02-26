//
//  UIScrollView+Extensions.swift
//  Marvel
//
//  Created by Ahmed Gamal on 25/02/2024.
//

import Foundation
import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
    
    func scrollToBottom(animated: Bool) {
        var y: CGFloat = 0.0
        let height = self.frame.size.height
        if self.contentSize.height > height {
            y = self.contentSize.height - height
        }
        self.setContentOffset(.init(x: 0, y: y), animated: animated)
    }
}
