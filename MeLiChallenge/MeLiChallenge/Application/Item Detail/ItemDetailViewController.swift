//
//  ItemDetailViewController.swift
//  MeLiChallenge
//
//  Created by InfinixSoft on 24/03/2024.
//

import UIKit

final class ItemDetailViewController: BaseViewController {
    
    @IBOutlet weak var itemConditionLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemThumbImage: UIImageView!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountLabel: UILabel!
    @IBOutlet weak var installmentsLabel: UILabel!
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
        sellerCollectionViewSetup()
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
        itemNameLabel.text      = viewModel.item.title
        itemThumbImage.getImage(from: viewModel.item.thumbnail)
        
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
        return viewModel.sellerItems.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = String(describing: ItemListGridCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                      for: indexPath) as! ItemListGridCollectionViewCell
        cell.setup(with: viewModel.sellerItems.value[indexPath.row])
        return cell
    }
}

extension ItemDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: (height * 2/3), height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.sellerItems.value[indexPath.row]
        let vc = ItemDetailViewController(item: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
