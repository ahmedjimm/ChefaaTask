//
//  CharacterCell.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var lblCharacterName: UILabel!
    @IBOutlet weak var imgCharacter: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(with model:CharacterCellVM){
        imgCharacter.loadFromUrl(url: model.imgUrl)
        lblCharacterName.text = model.characterName
    }
    
}
