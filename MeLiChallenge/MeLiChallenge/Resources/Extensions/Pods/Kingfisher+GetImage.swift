//
//  Kingfisher+GetImage.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 21/03/2024.
//

import Foundation
import Kingfisher

extension UIImageView {
    func getImage(from imageURL: String?, with placeholder: UIImage? = nil) {
        guard let imageURL = imageURL else {
            image = placeholder
            return
        }

        kf.indicatorType = .activity

        let imageURL_ = URL(string: imageURL)
        
        let processor = DownsamplingImageProcessor(size: bounds.size)

        kf.setImage(
            with: imageURL_,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
    
    func cancelDownloadImage() {
        kf.cancelDownloadTask()
    }
}
