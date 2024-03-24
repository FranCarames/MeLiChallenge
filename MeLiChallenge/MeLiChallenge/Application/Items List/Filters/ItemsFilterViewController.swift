//
//  ItemsFilterViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class ItemsFilterViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: ViewModel
    
    init(availableFilters: [GetItemsFilter]) {
        viewModel = .init(availableFilters: availableFilters)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filtros"
        
        tableViewSetup()
        observersSetup()
    }
    
    private func tableViewSetup() {
        tableView.delegate   = self
        tableView.dataSource = self
        
        let cellName = String(describing: FilterValueTableViewCell.self)
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        let insets = UIEdgeInsets(
            top: 0, left: 0, bottom: UIApplication.shared.keyWindow_?.safeAreaInsets.bottom ?? 0, right: 0)
        tableView.contentInset = insets
        
        tableView.separatorStyle = .singleLine
        
        tableView.reloadData()
    }
    
    private func observersSetup() {
//        filterTf.rx.text.bind(to: viewModel.keyword).disposed(by: disposeBag)
//        
//        viewModel.categories
//            .subscribe(
//                onNext: { [weak self] categories in
//                    self?.tableView.reloadData()
//                }
//            )
//            .disposed(by: disposeBag)
    }
}

extension ItemsFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.availableFilters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableFilters[section].values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: FilterValueTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! FilterValueTableViewCell
        let filterValue = viewModel.availableFilters[indexPath.section].values[indexPath.row]
        cell.setup(with: filterValue, isSelected: .random())
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterHeaderView()
        view.setup(with: viewModel.availableFilters[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height
    }
}
