//
//  ItemsFilterViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class ItemsFilterViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: ViewModel
    
    init(selectedSort: SortType, availableSorts: [SortType],
         selectedFilters: [GetItemsFilter], availableFilters: [GetItemsFilter]) {
        viewModel = .init(
            selectedSort: selectedSort,
            availableSorts: availableSorts,
            selectedFilters: selectedFilters,
            availableFilters: availableFilters
        )
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filtros"
        
        acceptButton.layer.cornerRadius  = 12
        acceptButton.layer.masksToBounds = true
        
        cancelButton.layer.cornerRadius  = 12
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth   = 1
        cancelButton.layer.borderColor   = UIColor.darkGray.cgColor
        
        tableViewSetup()
        observersSetup()
    }
    
    private func tableViewSetup() {
        tableView.delegate   = self
        tableView.dataSource = self
        
        let cellName = String(describing: FilterValueTableViewCell.self)
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        let insets = UIEdgeInsets(
            top: 0, left: 0, bottom: (UIApplication.shared.keyWindow_?.safeAreaInsets.bottom ?? 0) + 56, right: 0)
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
    
    @IBAction func acceptChangesTapped() {
        
    }
    
    @IBAction func cancelChangesTapped() {
        dismiss(animated: true)
    }
}

extension ItemsFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSetions()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: FilterValueTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! FilterValueTableViewCell
        switch viewModel.getCellType(for: indexPath.section) {
        case .sortType:
            if(indexPath.row == 0) {
                cell.setup(with: viewModel.selectedSort.name, isSelected: true)
            } else {
                cell.setup(with: viewModel.availableSorts[indexPath.row - 1].name, isSelected: false)
            }
        case .selectedFilter:
            if(indexPath.row == 0) {
                cell.setup(with: "Eliminar filtro", isSelected: false)
            } else {
                let index = viewModel.getCorrectedIndex(for: indexPath.section)
                let filter = viewModel.selectedFilters[index].values[indexPath.row - 1]
                cell.setup(with: filter.name, isSelected: true)
            }
        case .filter:
            let index = viewModel.getCorrectedIndex(for: indexPath.section)
            let filter = viewModel.availableFilters[index].values[indexPath.row]
            cell.setup(with: filter.name, isSelected: false)
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterHeaderView()
        let isSectionOpen = viewModel.isSectionOpen[section]
        
        switch viewModel.getCellType(for: section) {
        case .sortType:
            view.setup(with: "Ordenar por:", isSectionOpen: isSectionOpen, index: section, delegate: self)
        case .selectedFilter:
            let index = viewModel.getCorrectedIndex(for: section)
            view.setup(with: viewModel.selectedFilters[index].name, isSectionOpen: isSectionOpen, index: section, delegate: self)
        case .filter:
            let index = viewModel.getCorrectedIndex(for: section)
            view.setup(with: viewModel.availableFilters[index].name, isSectionOpen: isSectionOpen, index: section, delegate: self)
            break
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FilterHeaderView.height
    }
}

extension ItemsFilterViewController: FilterHeaderViewDelegate {
    func headerTapped(at index: Int) {
        viewModel.isSectionOpen[index].toggle()
        
        tableView.performBatchUpdates { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
        }
    }
}
