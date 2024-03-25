//
//  ItemImageCollectionViewCell.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 24/03/2024.
//

import UIKit

final class ItemImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.cancelDownloadImage()
    }
    
    func setup(with imageURL: String?) {
        productImage.getImage(from: imageURL)
    }
}
