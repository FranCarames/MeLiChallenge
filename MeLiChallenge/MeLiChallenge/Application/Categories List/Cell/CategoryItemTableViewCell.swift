//
//  CategoryItemTableViewCell.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 20/03/2024.
//

import UIKit

final class CategoryItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with category: MeLiCategory) {
        categoryNameLabel.text = category.name
    }
}
