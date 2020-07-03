//
//  ProductCell.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 29/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(product: Product) {
        
        productTitle.text = product.name
        
        // usamos Kingficher para bajar imagenes, en este caso, de Firebase
        if let url = URL(string: product.imageURL) {
            
            let placeholder = UIImage(named: "placeholder")
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
    }

    @IBAction func productClicked(_ sender: Any) {
    }
    

    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
}
