//
//  UIImageview+Extensions.swift
//  Marvel
//
//  Created by Ahmed Gamal on 23/02/2024.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    public func loadFromUrl(url: String, placeHolder: String = "marvel-logo", completion: ((UIImage?) -> Void)? = nil) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: bounds.size)
        kf.indicatorType = .activity
        kf.indicator?.view.tintColor = .red
        kf.setImage(
            with: url,
            placeholder: UIImage(named: placeHolder)?.imageWithColor(color1: .lightGray),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                // Check the result of caching
                switch result {
                case let .success(value):
                    // Image caching completed successfully
                    completion?(value.image)
                case .failure(let error):
                    // Handle the caching failure
                    print("Image caching failed with error: \(error.localizedDescription)")
                }
            })
    }
    
    public func cancelDownload(){
        self.kf.cancelDownloadTask()
    }
}

extension UIImage{
    func imageWithColor(color1: UIColor) -> UIImage {
         UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
         color1.setFill()

         let context = UIGraphicsGetCurrentContext()
         context?.translateBy(x: 0, y: self.size.height)
         context?.scaleBy(x: 1.0, y: -1.0)
         context?.setBlendMode(CGBlendMode.normal)

         let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
         context?.clip(to: rect, mask: self.cgImage!)
         context?.fill(rect)

         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()

         return newImage!
     }
}
