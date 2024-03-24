//
//  FilterHeaderView.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class FilterHeaderView: BaseView {
    static var height: CGFloat { return 40 }
    
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func initialSetup() {
        super.initialSetup()
    }
    
    func setup(with filter: GetItemsFilter) {
        filterNameLabel.text = filter.name
    }
}
