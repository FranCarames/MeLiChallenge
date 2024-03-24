//
//  QuerySortTypeTableViewCell.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class QuerySortTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sortNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(with sortType: SortType, isSelected: Bool) {
        sortNameLabel.text = sortType.name
        accessoryType = isSelected ? .checkmark : .none
    }
}
