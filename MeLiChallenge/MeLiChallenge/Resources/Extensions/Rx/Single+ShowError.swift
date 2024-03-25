//
//  Single+ShowError.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 25/03/2024.
//

import RxSwift
import RxCocoa
import Alamofire

extension Single where Trait == SingleTrait {
    func showError(_ show: Bool) -> Single<Element> {
        return self
            .do(
                onError: { error in
                    if show {
                        guard
                            let topVC = UIViewController.getTopViewController()
                        else { return }
                        
                        topVC.showError(error)
                    }
                }
            )
    }
}
