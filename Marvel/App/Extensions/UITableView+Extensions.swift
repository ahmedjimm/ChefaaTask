//
//  UITableView+Extensions.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import UIKit

extension UITableView{
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
