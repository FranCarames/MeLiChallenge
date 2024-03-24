//
//  ItemListCollectionViewCell.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class ItemListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemThumbImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountLabel: UILabel!
    @IBOutlet weak var installmentsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        itemThumbImage.layer.cornerRadius  = 8
        itemThumbImage.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemThumbImage.cancelDownloadImage()
    }
    
    func setup(with item: MeLiItem) {
        itemThumbImage.getImage(from: item.thumbnail)
        itemNameLabel.text = item.title
        
        if let discountPerc = item.discountPercentage,
           let originalPrice = item.originalPrice,
           let originalPriceStr = AmountFormatters.getMoneyAmount(for: Double(originalPrice)) {
            
            let labelAtt: [NSAttributedString.Key : Any] = [
                .foregroundColor : UIColor.darkGray.cgColor,
                .strikethroughStyle : 2
            ]
            
            let attStr = NSMutableAttributedString(
                string: originalPriceStr,
                attributes: labelAtt
            )
            
            originalPriceLabel.attributedText = attStr
            
            itemDiscountLabel.text = "\(Int(discountPerc))% OFF"
            
            originalPriceLabel.isHidden = false
            itemDiscountLabel.isHidden  = false
        } else {
            originalPriceLabel.isHidden = true
            itemDiscountLabel.isHidden  = true
        }
        
        if let price = item.price {
            itemPriceLabel.text = AmountFormatters.getMoneyAmount(for: Double(price))
        } else {
            itemPriceLabel.text = "Precio no disponible"
        }
        
        if let installmentsQty = item.installments?.quantity,
           let installmentsPrice = item.installments?.amount,
           let formattedPrice = AmountFormatters.getMoneyAmount(for: Double(installmentsPrice)) {
            installmentsLabel.text = "En \(installmentsQty) cuotas de \(formattedPrice)"
            installmentsLabel.isHidden = false
        } else {
            installmentsLabel.isHidden = true
        }
    }
}
