//
//  ArtWorkCell.swift
//  Marvel
//
//  Created by Ahmed Gamal on 24/02/2024.
//

import UIKit

protocol ArtWorkCellProtocal {
    func openMediaDetails(currentIndex:Int,mediaData:[MediaModel])
}
class ArtWorkCell: UITableViewCell {

    @IBOutlet weak var collectionViewItems: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    
    var items = [MediaModel]()
    var delegate: ArtWorkCellProtocal?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
        // Initialization code
    }
    
    private func configureTableView() {
        collectionViewItems.registerCellNib(cellClass: ItemArtWorkCell.self)
        collectionViewItems.delegate = self
        collectionViewItems.dataSource = self
    }
    
    func configCell(with model:ArtWorkCellVM){
        lblName.text = model.name
        items = model.Items
        collectionViewItems.reloadData()
    }
}

extension ArtWorkCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as ItemArtWorkCell
        cell.configCell(with: items[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = collectionView.bounds.width / 3.7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openMediaDetails(currentIndex: indexPath.row, mediaData: items)
    }
   
}
