//
//  FilterValueTableViewCell.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class FilterValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterValueLabel: UILabel!
    @IBOutlet weak var isSelectedImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(with valueName: String?, isSelected: Bool) {
        filterValueLabel.text = valueName
        isSelectedImage.image = isSelected ? UIImage(named: "ic_circle_full") : UIImage(named: "ic_circle")
    }
}
