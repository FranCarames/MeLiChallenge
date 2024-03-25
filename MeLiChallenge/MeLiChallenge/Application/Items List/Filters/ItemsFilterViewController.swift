//
//  ItemsFilterViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

protocol ItemsFilterViewControllerDelegate: AnyObject {
    func filtersUpdated(selectedSort: SortType, selectedFilters: [GetItemsFilter])
}

final class ItemsFilterViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel: ViewModel
    
    weak var delegate: ItemsFilterViewControllerDelegate?
    
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
        
        buttonsSetup()
        resetButtonSetup()
        tableViewSetup()
        observersSetup()
    }
    
    func setup(delegate: ItemsFilterViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func tableViewSetup() {
        tableView.delegate   = self
        tableView.dataSource = self
        
        let cellName = String(describing: FilterValueTableViewCell.self)
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        tableView.contentInset = insets
        
        tableView.separatorStyle = .singleLine
        
        tableView.reloadData()
    }
    
    private func observersSetup() {
    }
    
    private func buttonsSetup() {
        acceptButton.layer.cornerRadius  = 12
        acceptButton.layer.masksToBounds = true
        
        cancelButton.layer.cornerRadius  = 12
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth   = 1
        cancelButton.layer.borderColor   = UIColor.darkGray.cgColor
    }
    
    private func resetButtonSetup() {
        let resetButton = UIBarButtonItem(
            image: UIImage(systemName: "eraser")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(resetFiltersTapped)
        )
        
        resetButton.tintColor = .white
        
        navigationItem.setRightBarButton(resetButton, animated: true)
    }
    
    @objc private func resetFiltersTapped() {
        viewModel.resetFiltersTapped()
        tableView.reloadData()
    }
    
    @IBAction func acceptChangesTapped() {
        guard
            let newSortType = viewModel.sorts.first(where: { $0.isSelected == true })
        else { return }
        
        let newFilters = viewModel.filters.filter({ $0.isSelected == true })
        
        newFilters.forEach { $0.values.removeAll(where: { $0.isSelected == false }) }
        
        delegate?.filtersUpdated(
            selectedSort: newSortType,
            selectedFilters: newFilters
        )
        
        dismiss(animated: true)
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
            cell.setup(with: viewModel.sorts[indexPath.row])
        case .filters:
            let index = viewModel.getCorrectedIndex(for: indexPath.section)
            let filter = viewModel.filters[index]
            
            if viewModel.needToShowClearFilter(in: indexPath.section) {
                if(indexPath.row == 0) {
                    cell.setup(with: "Eliminar Filtro", isSelected: false)
                } else {
                    let filterValue = filter.values[indexPath.row - 1]
                    cell.setup(with: filterValue)
                }
            } else {
                let filter = viewModel.filters[index].values[indexPath.row]
                cell.setup(with: filter)
            }
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.getCellType(for: indexPath.section) {
        case .sortType:
            viewModel.newSortSelected(at: indexPath.row)
        case .filters:
            let needToRefresh = viewModel.newFilterSelected(at: indexPath)
            
            if needToRefresh {
                tableView.performBatchUpdates { [weak self] in
                    self?.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterHeaderView()
        let isSectionOpen = viewModel.isSectionOpen[section]
        
        switch viewModel.getCellType(for: section) {
        case .sortType:
            view.setup(with: "Ordenar por:", isSectionOpen: isSectionOpen, index: section, delegate: self)
        case .filters:
            let index = viewModel.getCorrectedIndex(for: section)
            view.setup(with: viewModel.filters[index].name, isSectionOpen: viewModel.isSectionOpen[index], index: section, delegate: self)
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
