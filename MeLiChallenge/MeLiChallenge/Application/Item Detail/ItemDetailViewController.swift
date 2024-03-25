//
//  ItemDetailViewController.swift
//  MeLiChallenge
//
//  Created by Franco Carames on 24/03/2024.
//

import UIKit

final class ItemDetailViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet weak var itemConditionLabel: UILabel!
    @IBOutlet weak var reviewStars: CosmosCustomView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPicturesCollectionView: UICollectionView!
    @IBOutlet weak var itemPicturesPageControl: UIPageControl!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountLabel: UILabel!
    @IBOutlet weak var installmentsLabel: UILabel!
    @IBOutlet weak var itemStockLabel: UILabel!
    @IBOutlet weak var productFeaturesLabel: UILabel!
    @IBOutlet weak var sellerItemsView: UIView!
    @IBOutlet weak var sellerItemsCollectionView: UICollectionView!
    
    private let viewModel: ViewModel
    
    init(item: MeLiItem) {
        viewModel = .init(item: item)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observersSetup()
        viewsSetup()
        itemPicturesCollectionViewSetup()
        sellerCollectionViewSetup()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        itemPicturesCollectionView.layoutIfNeeded()
        itemPicturesCollectionView.reloadData()
    }
    
    private func observersSetup() {
        viewModel.sellerItems
            .subscribe(
                onNext: { [weak self] items in
                    self?.sellerItemsCollectionView.reloadData()
                    self?.sellerItemsView.isHidden = items.isEmpty
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func viewsSetup() {
        itemConditionLabel.text = viewModel.item.itemCondition
        
        reviewStars.rating = Double.random(in: 1...5)
        reviewsLabel.text = "(\(Int.random(in: 1...1000)))"
        
        itemNameLabel.text      = viewModel.item.title
        
        itemPicturesPageControl.numberOfPages = viewModel.itemImages.count
        itemPicturesPageControl.currentPage   = 0
        
        if let discountPerc = viewModel.item.discountPercentage,
           let originalPrice = viewModel.item.originalPrice,
           let originalPriceStr = AmountFormatters.getMoneyAmount(for: Double(originalPrice)) {
            
            let labelAtt: [NSAttributedString.Key : Any] = [
                .foregroundColor : UIColor.darkGray.cgColor,
                .strikethroughStyle : 2
            ]
            
            let attStr = NSMutableAttributedString(
                string: originalPriceStr,
                attributes: labelAtt
            )
            
            originalPriceLabel.attributedText = attStr
            
            itemDiscountLabel.text = "\(Int(discountPerc))% OFF"
            
            originalPriceLabel.isHidden = false
            itemDiscountLabel.isHidden  = false
        } else {
            originalPriceLabel.isHidden = true
            itemDiscountLabel.isHidden  = true
        }
        
        if let price = viewModel.item.price {
            itemPriceLabel.text = AmountFormatters.getMoneyAmount(for: Double(price))
        } else {
            itemPriceLabel.text = "Precio no disponible"
        }
        
        if let installmentsQty = viewModel.item.installments?.quantity,
           let installmentsPrice = viewModel.item.installments?.amount,
           let formattedPrice = AmountFormatters.getMoneyAmount(for: Double(installmentsPrice)) {
            installmentsLabel.text = "En \(installmentsQty) cuotas de \(formattedPrice)"
            installmentsLabel.isHidden = false
        } else {
            installmentsLabel.isHidden = true
        }
        
        if let stock = viewModel.item.availableQuantity, stock > 0 {
            if stock == 1 {
                itemStockLabel.text = "Stock disponible: Ultimo Disponible!"
            } else {
                let qty = (stock >= 100) ? "+100" : "\(stock)"
                itemStockLabel.text = "Stock disponible: \(qty) unidades"
            }
        } else {
            itemStockLabel.text = "No hay stock disponible"
        }
        
        let featuresStr = viewModel.item.attributes
            .filter( { $0.id != "ITEM_CONDITION" } ) // Ya lo muestro en otro label
            .compactMap { attribute in
                if let attName = attribute.name, let attValue = attribute.valueName {
                    return [attName, attValue].joined(separator: ": ")
                } else {
                    return nil
                }
            }
            .joined(separator: "\n ● ")
        
        productFeaturesLabel.text = featuresStr
    }
    
    private func shareButtonSetup() {
        let shareButton = UIBarButtonItem(
            image: UIImage(named: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate).withTintColor(.white),
            style: .plain,
            target: self,
            action: #selector(shareTapped)
        )
        
        navigationItem.setRightBarButton(shareButton, animated: true)
    }
    
    @objc func shareTapped() {
        
    }
    
    private func itemPicturesCollectionViewSetup() {
        itemPicturesCollectionView.delegate   = self
        itemPicturesCollectionView.dataSource = self
        
        let cellName = String(describing: ItemImageCollectionViewCell.self)
        itemPicturesCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        
        itemPicturesCollectionView.reloadData()
    }
    
    private func sellerCollectionViewSetup() {
        sellerItemsCollectionView.delegate   = self
        sellerItemsCollectionView.dataSource = self
        
        let gridCellName = String(describing: ItemListGridCollectionViewCell.self)
        sellerItemsCollectionView.register(UINib(nibName: gridCellName, bundle: nil), forCellWithReuseIdentifier: gridCellName)
        
        let insets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        sellerItemsCollectionView.contentInset = insets
        
        sellerItemsCollectionView.reloadData()
    }
}

extension ItemDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemPicturesCollectionView {
            return viewModel.itemImages.count
        } else {
            return viewModel.sellerItems.value.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemPicturesCollectionView {
            let cellName = String(describing: ItemImageCollectionViewCell.self)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                          for: indexPath) as! ItemImageCollectionViewCell
            cell.setup(with: viewModel.itemImages[indexPath.row])
            return cell
        } else {
            let cellName = String(describing: ItemListGridCollectionViewCell.self)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                          for: indexPath) as! ItemListGridCollectionViewCell
            cell.setup(with: viewModel.sellerItems.value[indexPath.row])
            return cell
        }
    }
}

extension ItemDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == itemPicturesCollectionView {
            return collectionView.frame.size
        } else {
            let height = collectionView.frame.height
            return CGSize(width: (height * 2/3), height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView == itemPicturesCollectionView) ? 0 : 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView == itemPicturesCollectionView) ? 0 : 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == itemPicturesCollectionView {
            
        } else {
            let item = viewModel.sellerItems.value[indexPath.row]
            let vc = ItemDetailViewController(item: item)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == itemPicturesCollectionView {
            itemPicturesPageControl.currentPage = scrollView.currentPage
        }
    }
}

extension UIScrollView {
    var currentPage: Int {
        return Int((contentOffset.x + (0.5 * frame.size.width)) / frame.width)
    }
}
