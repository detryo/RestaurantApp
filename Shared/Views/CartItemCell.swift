//
//  CartItemCell.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 13/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

protocol CartItemDelegate: class {
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {
    
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    private var item: Product!
    weak var delegate: CartItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product, delegate: CartItemDelegate) {
        
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.uk
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLabel.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
    }

  
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(product: item)
    }
}
