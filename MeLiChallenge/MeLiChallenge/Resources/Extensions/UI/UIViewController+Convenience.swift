//
//  UIViewController+Convenience.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 25/03/2024.
//

import UIKit
import Alamofire

extension UIViewController {
    class func getTopViewController() -> UIViewController? {
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            return navigationController.visibleViewController
        }
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        
        return nil
    }
    
    // Returns the navigation controller if it exists
    class func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow_?.rootViewController  {
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    var isPresented: Bool {
        get {
            return presentingViewController != nil
        }
    }
    
    var isFirstControllerOnStack: Bool {
        return navigationController?.viewControllers.first == self
    }
    
    func insertVC(_ vc: UIViewController, in containerView: UIView,
                  top: CGFloat = 0.0, leading: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        addChild(vc)
        containerView.addSubview(vc.view)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.translatesAutoresizingMaskIntoConstraints       = false
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo:      containerView.topAnchor,      constant: top),
            vc.view.leadingAnchor.constraint(equalTo:  containerView.leadingAnchor,  constant: leading),
            vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailing),
            vc.view.bottomAnchor.constraint(equalTo:   containerView.bottomAnchor,   constant: bottom)
        ])
    }
    
    func insertView(_ view: UIView, in containerView: UIView,
                    top: CGFloat = 0.0, leading: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        
        containerView.addSubview(view)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints          = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo:      containerView.topAnchor,      constant: top),
            view.leadingAnchor.constraint(equalTo:  containerView.leadingAnchor,  constant: leading),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: trailing),
            view.bottomAnchor.constraint(equalTo:   containerView.bottomAnchor,   constant: bottom)
        ])
    }
    
    func animatedLayoutIfNeeded(duration: Double = 0.3) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func getErrorMessage(from error: Error?) -> String {
        let defaultMessage = "Algo salio mal! Por favor intente nuevamente mas tarde."
        
        guard let error = error else {
            return defaultMessage
        }
        
        if let error = error.asAFError {
            switch error {
            case .invalidURL:
                return "URL Invalida"
            case .sessionTaskFailed:
                return "Parece que no hay internet"
            default: break
            }
        }
        
        if let error = error.asAFError?.underlyingError as? AppError {
            let message = error.message
            return error.message
        }
        
        if let error_ = (error as? AFError)?.underlyingError as? AppError {
            return error_.message
        }
        
        if let error = error as? AppError {
            return error.message
        }
        
        return error.localizedDescription
    }
    
    func showError(_ error: Error? = nil) {
        let alertVC = UIAlertController(title: "MeLiChallenge", message: getErrorMessage(from: error),
                                        preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)

        alertVC.addAction(okAction)

        present(alertVC, animated: true)
    }
}
