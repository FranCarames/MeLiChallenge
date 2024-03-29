//
//  CategoriesListViewController.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 20/03/2024.
//

import UIKit
import RxCocoa

final class CategoriesListViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet weak var filterTf: UITextField!
    @IBOutlet weak var filterContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selecciona la categoria de tu producto"
        
        filterContainer.layer.cornerRadius  = 12
        filterContainer.layer.masksToBounds = true
        
        tableViewSetup()
        observersSetup()
    }
    
    private func tableViewSetup() {
        tableView.delegate   = self
        tableView.dataSource = self
        
        let cellName = String(describing: CategoryItemTableViewCell.self)
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        let insets = UIEdgeInsets(
            top: 0, left: 0, bottom: UIApplication.shared.keyWindow_?.safeAreaInsets.bottom ?? 0, right: 0)
        tableView.contentInset = insets
        
        tableView.separatorStyle = .singleLine
        
        tableView.reloadData()
    }
    
    private func observersSetup() {
        filterTf.rx.text.bind(to: viewModel.keyword).disposed(by: disposeBag)
        
        viewModel.loading
            .distinctUntilChanged()
            .subscribe(
                onNext: { isLoading in ProgressHUD.show(isLoading) }
            )
            .disposed(by: disposeBag)
        
        viewModel.categories
            .subscribe(
                onNext: { [weak self] categories in
                    self?.tableView.reloadData()
                }
            )
            .disposed(by: disposeBag)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories.value[indexPath.row]
        let vc = ItemsListViewController(category: category)
        navigationController?.pushViewController(vc, animated: true)
    }
}
