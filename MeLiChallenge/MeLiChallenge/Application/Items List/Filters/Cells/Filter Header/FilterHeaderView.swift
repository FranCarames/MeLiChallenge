//
//  FilterHeaderView.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 24/03/2024.
//

import UIKit

protocol FilterHeaderViewDelegate: AnyObject {
    func headerTapped(at index: Int)
}

final class FilterHeaderView: BaseView {
    static var height: CGFloat { return 40 }
    
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var isSectionOpenIndicator: UIImageView!
    
    private var index: Int?
    
    weak var delegate: FilterHeaderViewDelegate?
    
    override func initialSetup() {
        super.initialSetup()
    }
    
    func setup(with filterName: String?, isSectionOpen: Bool, index: Int, delegate: FilterHeaderViewDelegate) {
        filterNameLabel.text = filterName
        isSectionOpenIndicator.image = UIImage(systemName: isSectionOpen ? "chevron.up" : "chevron.down" )
        self.index = index
        self.delegate = delegate
    }
    
    @IBAction func headerTapped() {
        guard let index = index else { return }
        delegate?.headerTapped(at: index)
    }
}
