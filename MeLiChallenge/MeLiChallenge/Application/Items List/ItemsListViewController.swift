//
//  ItemsListViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 20/03/2024.
//

import UIKit

final class ItemsListViewController: BaseViewController {
    
    @IBOutlet weak var filterTf: UITextField!
    @IBOutlet weak var filterContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel: ViewModel
    
    init(category: MeLiCategory) {
        viewModel = .init(category: category)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.category.name
        
        filterContainer.layer.cornerRadius  = 12
        filterContainer.layer.masksToBounds = true
        
        collectionViewSetup()
        observersSetup()
    }
    
    private func collectionViewSetup() {
        collectionView.delegate   = self
        collectionView.dataSource = self

        let listCellName = String(describing: ItemListCollectionViewCell.self)
        collectionView.register(UINib(nibName: listCellName, bundle: nil), forCellWithReuseIdentifier: listCellName)
        
        let gridCellName = String(describing: ItemListGridCollectionViewCell.self)
        collectionView.register(UINib(nibName: gridCellName, bundle: nil), forCellWithReuseIdentifier: gridCellName)
        
        let insets = UIEdgeInsets(
            top: 8, left: 0, bottom: UIApplication.shared.keyWindow_?.safeAreaInsets.bottom ?? 0, right: 0)
        collectionView.contentInset = insets
        
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    private func observersSetup() {
        filterTf.rx.text.bind(to: viewModel.keyword).disposed(by: disposeBag)
        
        viewModel.loading
            .distinctUntilChanged()
            .subscribe(
                onNext: { isLoading in ProgressHUD.show(isLoading) }
            )
            .disposed(by: disposeBag)
        
        viewModel.items
            .subscribe(
                onNext: { [weak self] items in
                    self?.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }
    
    @IBAction func filtersTapped() {
        guard let selectedSort = viewModel.itemsResponse.value?.sort else { return }
        
        let vc = ItemsFilterViewController(
            selectedSort: selectedSort,
            availableSorts: viewModel.itemsResponse.value?.availableSorts ?? [], 
            selectedFilters: viewModel.itemsResponse.value?.filters ?? [],
            availableFilters: viewModel.itemsResponse.value?.availableFilters ?? []
        )
        
        vc.setup(delegate: self)
        
        present(BaseNavigationController(rootViewController: vc), animated: true)
    }
}

extension ItemsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UIDevice.current.orientation.isLandscape {
            let cellName = String(describing: ItemListGridCollectionViewCell.self)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                          for: indexPath) as! ItemListGridCollectionViewCell
            cell.setup(with: viewModel.items.value[indexPath.row])
            return cell
        } else {
            let cellName = String(describing: ItemListCollectionViewCell.self)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                          for: indexPath) as! ItemListCollectionViewCell
            cell.setup(with: viewModel.items.value[indexPath.row])
            return cell
        }
    }
}

extension ItemsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            let width = (collectionView.frame.width - 32) / 3
            return CGSize(width: width, height: width * 1.5)
        } else {
            return CGSize(width: collectionView.frame.width, height: 140)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items.value[indexPath.row]
        let vc = ItemDetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ItemsListViewController: ItemsFilterViewControllerDelegate {
    func filtersUpdated(selectedSort: SortType, selectedFilters: [GetItemsFilter]) {
        viewModel.getItems(
            selectedSort: selectedSort
        )
//        viewModel.selectedSort.accept(selectedSort)
//        viewModel.selectedFilters.accept(selectedFilters)
    }
}
