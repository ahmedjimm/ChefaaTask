//
//  RelatedLinkCell.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import UIKit

class RelatedLinkCell: UITableViewCell {

    @IBOutlet weak var lblType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(with model:RelatedLinkModel){
        lblType.text = model.type
    }
    
}
