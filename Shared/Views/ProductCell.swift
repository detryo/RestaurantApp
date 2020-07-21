//
//  ProductCell.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 29/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
    func productAddToCart(product: Product)
}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        
        self.product = product
        self.delegate = delegate
        productTitle.text = product.name
        
        // usamos Kingficher para bajar imagenes, en este caso, de Firebase
        if let url = URL(string: product.imageURL) {
            
            let placeholder = UIImage(named: AppImages.placeholder)
            productImage.kf.indicatorType = .activity
        
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.uk
        
        // convert our price, becouse is Double in String
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        // if the Product being configured is also a favorite and
        // we're going to do that by comparing this product
        // with all of the products in our favorite array
        // And if it exists in that array then it's a favorite
        if UserService.favorites.contains(product) {
            favoriteButton.setImage(UIImage(named: AppImages.filledStar), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: AppImages.emptyStar), for: .normal)
        }
    }
    
    func userServiceGuest() {
        if UserService.isGuest {
            return
        }
    }

    @IBAction func favoriteClicked(_ sender: Any) {
        userServiceGuest()
        delegate?.productFavorited(product: product)
    }
    

    @IBAction func addToCartClicked(_ sender: Any) {
        userServiceGuest()
        delegate?.productFavorited(product: product)
    }
    
}
