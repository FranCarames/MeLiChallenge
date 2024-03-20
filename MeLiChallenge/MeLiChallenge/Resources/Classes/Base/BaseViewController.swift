//
//  BaseViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 19/03/2024.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    var navBarTintColor: UIColor { .black }
    var prefersNavigationBarHidden: Bool { return false }
    
    var updateSafeAreaWithKeyboardChanges: Bool { false }

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        addObserversToKeyboardChangesIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = navBarTintColor
        navigationController?.setNavigationBarHidden(prefersNavigationBarHidden, animated: animated)
    }
    
    private func addObserversToKeyboardChangesIfNeeded() {
        guard updateSafeAreaWithKeyboardChanges == true else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardHeight =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            else { return }

        let bottomMargin = UIApplication.shared.keyWindow_?.safeAreaInsets.bottom ?? 0
        
        updateAditionalSafeAreaBottomInset(with: keyboardHeight - bottomMargin)
    }

    @objc func keyboardWillHide() {
        updateAditionalSafeAreaBottomInset(with: 0)
    }
    
    func updateAditionalSafeAreaBottomInset(with newInset: Double) {
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: newInset, right: 0)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
