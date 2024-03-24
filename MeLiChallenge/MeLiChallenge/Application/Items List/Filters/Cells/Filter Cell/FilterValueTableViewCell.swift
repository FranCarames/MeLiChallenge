//
//  FilterValueTableViewCell.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class FilterValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(with filterValue: FilterValue, isSelected: Bool) {
        filterValueLabel.text = filterValue.name
        accessoryType = isSelected ? .checkmark : .none
    }
}
