//
//  LoadingRelay.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 20/03/2024.
//

import Foundation
import RxSwift

final class LoadingRelay: ObservableType {
    private let subject = BehaviorSubject<Bool>(value: false)
    private var numberOfRequest = 0 { didSet { updateSubject() } }
    
    private func updateSubject() {
        let requestsInProgress = numberOfRequest > 0
        self.subject.onNext(requestsInProgress)
    }
    
    func requestStarted() {
        numberOfRequest += 1
    }
    
    func requestFinished() {
        guard numberOfRequest > 0 else { return }
        numberOfRequest -= 1
    }

    /// Current value of behavior subject
    public var value: Bool {
        // this try! is ok because subject can't error out or be disposed
        return try! self.subject.value()
    }

    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Bool {
        self.subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Bool> {
        self.subject.asObservable()
    }
}
