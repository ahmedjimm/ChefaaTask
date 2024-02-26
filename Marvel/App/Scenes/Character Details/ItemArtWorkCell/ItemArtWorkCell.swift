//
//  ItemArtWorkCell.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import UIKit

class ItemArtWorkCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(with model:MediaModel){
        lblName.text = model.title ?? ""
        imgItem.loadFromUrl(url: model.thumbnail?.url ?? "")
    }

}
