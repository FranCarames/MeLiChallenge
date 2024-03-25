//
//  CategoriesListViewModel.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 20/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension CategoriesListViewController {
    final class ViewModel {
        private let disposeBag = DisposeBag()
        
        let loading = LoadingRelay()
        
        let keyword = BehaviorRelay<String?>(value: nil)
        private let categories_ = BehaviorRelay(value: [MeLiCategory]())
        let categories = BehaviorRelay(value: [MeLiCategory]())
        
        init() {
            getCategories()
            
            Observable
                .combineLatest(keyword.distinctUntilChanged(), categories_)
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .compactMap { (keyword, categories_) -> [MeLiCategory] in
                    guard
                        let cleanKeyword = keyword?.applyingTransform(.stripDiacritics, reverse: false),
                        cleanKeyword.isEmpty == false
                    else { return categories_ }
                    
                    return categories_.filter {
                        $0.name?
                            .applyingTransform(.stripDiacritics, reverse: false)?
                            .localizedCaseInsensitiveContains(cleanKeyword) == true
                    }
                }
                .bind(to: categories)
                .disposed(by: disposeBag)
        }
        
        func getCategories() {
            let apiRequest = Requests.Categories.Get()
            
            loading.requestStarted()
            
            apiRequest
                .apiCall(modelArray: MeLiCategory.self)
                .showError(true)
                .subscribe(
                    onSuccess: { [weak self] categories in
                        self?.loading.requestFinished()
                        self?.categories_.accept(categories)
                    },
                    onFailure: { [weak self] error in
                        self?.loading.requestFinished()
                    }
                )
                .disposed(by: disposeBag)
        }

    }
}

//extension BulkSendUsersSelectionViewController {
//    typealias TicketGroup = AvailableTicketsToSendViewController.TicketGroup
//    
//    final class ViewModel {
//        private let disposeBag = DisposeBag()
//        
//        let loading = LoadingRelay()
//
//        private let users        = BehaviorRelay(value: [User]())
//        private let usersSorted_ = BehaviorRelay(value: [UsersLetter]())
//        let usersSorted          = BehaviorRelay(value: [UsersLetter]())
//        let error                = BehaviorRelay<Error?>(value: nil)
//        
//        let selectedUsers = BehaviorRelay(value: Set<User>())
//        
//        let eventID:          String
//        let receiverRole:     ReceiverUsersType
//        let availableTickets: [TicketGroup]
//        
//        var allUsersSelected: Bool { return selectedUsers.value.count == users.value.count }
//        
//        lazy var followersPageManager = APIPageManager<User>(waitForFirstRequest: true) { [weak self] (page, _) in
//            let request = Requests.User.GetFollowers(userID: User.getCurrentUser()?.id, page: page)
//            return APIManager.User.getFollowers(request)
//        }
//        
//        init(of eventID: String, to receiverRole: ReceiverUsersType,
//             availableTickets: [TicketGroup]) {
//            
//            self.eventID          = eventID
//            self.receiverRole     = receiverRole
//            self.availableTickets = availableTickets
//
//            
//            
//            users
//                .map { users -> [UsersLetter] in
//                    var usersLetters = [UsersLetter?]()
//
//                    for user in users {
//                        let belongInAnyLetter = usersLetters
//                            .map { $0?.appendUserIfPossible(user) }
//                            .contains(true)
//
//                        if belongInAnyLetter == false {
//                            usersLetters.append(.init(with: user))
//                        }
//                    }
//
//                    return usersLetters
//                        .compactMap { $0 }
//                        .sorted(by: { $0.letter < $1.letter } )
//                }
//                .bind(to: usersSorted_)
//                .disposed(by: disposeBag)
//            
//            if receiverRole == .users {
//                followersPageManager.elements
//                    .observe(on: MainScheduler.instance)
//                    .map { $0.filterBomboArtists() }
//                    .bind(to: users)
//                    .disposed(by: disposeBag)
//
//                followersPageManager.loading
//                    .observe(on: MainScheduler.instance)
//                    .subscribe { [weak self] isLoading in
//                        if isLoading {
//                            self?.loading.requestStarted()
//                        } else {
//                            self?.loading.requestFinished()
//                        }
//                    }
//                    .disposed(by: disposeBag)
//            }
//            
//            reloadInfo()
//        }
//        
//        func reloadInfo() {
//            switch receiverRole {
//            case .vendors: getVendors()
//            case .users:   followersPageManager.reload()
//            }
//        }
//        
//        private func getVendors() {
//            let request = Requests.RRPP.GetTeam(eventID: eventID)
//
//            loading.requestStarted()
//
//            error.accept(nil)
//
//            APIManager.RRPP.GetTeam(request)
//                .do(onDispose: { [weak self] in self?.loading.requestFinished() } )
//                .subscribe(
//                    onSuccess: { [weak self] users in self?.users.accept(users) },
//                    onFailure: { [weak self] error in self?.error.accept(error) }
//                )
//                .disposed(by: disposeBag)
//        }
//        
//        func isUserSelected(_ user: User) -> Bool {
//            return selectedUsers.value.contains(user)
//        }
//
//        func userTapped(at index: IndexPath) {
//            if index.section == 0 {
//                if allUsersSelected {
//                    selectedUsers.accept([])
//                } else {
//                    selectedUsers.accept(Set<User>(users.value))
//                }
//            } else {
//                let tappedUser = usersSorted.value[index.section - 1].users[index.row]
//                
//                var selectedUsers_ = selectedUsers.value
//
//                if selectedUsers_.contains(tappedUser) {
//                    selectedUsers_.remove(tappedUser)
//                } else {
//                    selectedUsers_.insert(tappedUser)
//                }
//                
//                selectedUsers.accept(selectedUsers_)
//            }
//        }
//    }
//    
//    enum ReceiverUsersType {
//        case vendors
//        case users
//    }
//    
//    final class UsersLetter {
//        let letter: String
//        var users:  [User]
//
//        init?(with user: User) {
//            guard let firstLetter = user.nameToDisplay?.lowercased().first else { return nil }
//            letter  = String(firstLetter)
//            users = [user]
//        }
//
//        private init(letter: String, users: [User]) {
//            self.letter = letter
//            self.users  = users
//        }
//
//        func appendUserIfPossible(_ user: User) -> Bool {
//            guard let firstLetter = user.nameToDisplay?.lowercased().first else { return false }
//
//            let startsWithThisLetter = (firstLetter == letter.first)
//
//            if startsWithThisLetter {
//                users.append(user)
//            }
//
//            return startsWithThisLetter
//        }
//

//    }
//}
//
