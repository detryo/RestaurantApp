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
            productImage.kf.setImage(with: url)
        }
    }

    @IBAction func productClicked(_ sender: Any) {
    }
    

    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
}
