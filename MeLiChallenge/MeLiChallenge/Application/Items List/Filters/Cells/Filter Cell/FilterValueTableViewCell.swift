//
//  FilterValueTableViewCell.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit
import RxSwift

final class FilterValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterValueLabel: UILabel!
    @IBOutlet weak var isSelectedImage: UIImageView!
    
    var reusableDisposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reusableDisposeBag = DisposeBag()
    }
    
    func setup(with valueName: String?, isSelected: Bool) {
        filterValueLabel.text = valueName
        isSelectedImage.image =  UIImage(named: isSelected ? "ic_circle_full" : "ic_circle")
    }
    
    func setup(with sortType: SortType) {
        filterValueLabel.text = sortType.name
        
        sortType.rx.isSelectedRx
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isSelected in
                
                self?.isSelectedImage.image =  UIImage(named: isSelected ? "ic_circle_full" : "ic_circle")
            })
            .disposed(by: reusableDisposeBag)
    }
    
    func setup(with filterValue: FilterValue) {
        filterValueLabel.text = filterValue.name
        
        filterValue.rx.isSelectedRx
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isSelected in
                
                self?.isSelectedImage.image =  UIImage(named: isSelected ? "ic_circle_full" : "ic_circle")
            })
            .disposed(by: reusableDisposeBag)
    }
}

//final class UserWithFollowTableViewCell: UITableViewCell {
//    
//    @IBOutlet weak var userImage: UIImageView!
//    @IBOutlet weak var userNameLabel: UILabel!
//    @IBOutlet weak var followUnfollowContainer: UIView!
//    @IBOutlet weak var followUnfollowLabel: UILabel!
//    
//    func setup(with user: User, delegate: UserWithFollowTableViewCellDelegate) {
//        
//        self.delegate = delegate
//        
//        userImage.getImage(from: user.profilePicture, with: UIImage.profilePlaceholder)
//        userNameLabel.text = user.nameToDisplay
//        
//        if user.id == User.getCurrentUser()?.id {
//            followUnfollowContainer.isHidden = true
//        } else {
//            followUnfollowContainer.isHidden = false
//            
//            
//        }
//    }
//    
//    func setup(with seller: User, sellerID: String?) {
//        userImage.getImage(from: seller.profilePicture, with: UIImage.profilePlaceholder)
//        userNameLabel.text = seller.nameToDisplay
//
//        followUnfollowContainer.isHidden = true
//        
//        if seller.id == sellerID {
//            accessoryType = .checkmark
//        } else {
//            accessoryType = .none
//        }
//    }
//    
//    private func validateUserIsLoggedIn() -> Bool {
//        let message = "Para seguir a este usuario tenes que tener una cuenta Bombo"
//
//        guard User.getCurrentUser() == nil else { return true }
//        
//        let alertController = UIAlertController(title: "Bombo", message: message, preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        
//        let loginAction = UIAlertAction(title: "Iniciar Sesión", style: .default) { _ in
//            User.guestUserLogguedOut()
//            NavigationHelper.setAppFlow()
//        }
//        
//        alertController.addAction(okAction)
//        alertController.addAction(loginAction)
//        
//        UIViewController.getTopViewController()?.present(alertController, animated: true)
//        
//        return false
//    }
//
//    @IBAction func followUnfollowTapped() {
//        guard validateUserIsLoggedIn() else { return }
//        delegate?.followUnfollowTapped(at: self)
//    }
//}
