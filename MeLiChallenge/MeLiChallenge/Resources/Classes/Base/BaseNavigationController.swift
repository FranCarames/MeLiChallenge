//
//  BaseNavigationController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.children.last?.preferredStatusBarStyle ?? .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return children.last?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return children.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationBar.titleTextAttributes = textAttributes
        navigationBar.backIndicatorImage = UIImage(named: "chevron.left")?.withTintColor(.white)
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "chevron.left")?.withTintColor(.white)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
    }
}
