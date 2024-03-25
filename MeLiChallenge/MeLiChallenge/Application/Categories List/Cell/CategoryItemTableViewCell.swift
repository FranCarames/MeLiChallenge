//
//  CategoryItemTableViewCell.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 20/03/2024.
//

import UIKit

final class CategoryItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(with category: MeLiCategory) {
        categoryNameLabel.text = category.name
    }
}
