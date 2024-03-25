//
//  BaseView.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 24/03/2024.
//

import UIKit

class BaseView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.frame = bounds
        contentView.frame = bounds
        
        self.addSubview(contentView)
        
        initialSetup()
    }
    
    func initialSetup() {
//        Override this to setup all the views for the first time
    }
}
