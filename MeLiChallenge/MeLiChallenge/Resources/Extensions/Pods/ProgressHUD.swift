//
//  ProgressHUD.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 24/03/2024.
//

import Foundation
import SVProgressHUD

final class ProgressHUD {
    
    static func show(_ show: Bool, message: String? = nil) {
        UIApplication.shared.sendAction(
            #selector(UIApplication.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
        
        if show {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.show(withStatus: message)
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    static func showSuccess(message: String? = nil) {
        UIApplication.shared.sendAction(
            #selector(UIApplication.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
        
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.showSuccess(withStatus: message)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            SVProgressHUD.dismiss()
        })
    }
}
