//
//  CategoriesListViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 20/03/2024.
//

import UIKit
import RxCocoa

final class CategoriesListViewController: BaseViewController {
    
    @IBOutlet weak var filterTf: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        observersSetup()
    }
    
    private func tableViewSetup() {
        tableView.delegate   = self
        tableView.dataSource = self
        
        let cellName = String(describing: CategoryItemTableViewCell.self)
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(retryApiCalls), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.reloadData()
    }
    
    private func observersSetup() {
//        viewModel.loading
//            .distinctUntilChanged()
//            .subscribe(
//                onNext: { [weak self] isLoading in
//                    guard !isLoading else { return }
//                    self?.tableView.animateRefreshControl(isLoading)
//                }
//            )
//            .disposed(by: disposeBag)
        
        viewModel.categories
            .subscribe(
                onNext: { [weak self] categories in
                    self?.tableView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    @objc func retryApiCalls() {
        viewModel.getCategories()
    }
}

extension CategoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: CategoryItemTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! CategoryItemTableViewCell
        let category = viewModel.categories.value[indexPath.row]
        cell.setup(with: category)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch viewModel.getCellType(for: indexPath) {
//        case .eventScroll:
//            break
//        case .singleEvent(let event):
//            let vc = EventDetailViewController(event: event)
//            push(vc, hideTabBarWhenPushed: true)
//        case .news(let new):
//            let vc = NewsDetailViewController(new)
//            push(vc, hideTabBarWhenPushed: true)
//        }
//    }
}
