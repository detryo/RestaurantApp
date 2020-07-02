//
//  AdminProductsVC.swift
//  RestaurantAdmin
//
//  Created by Cristian Sedano Arenas on 02/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    var selectedProduct : Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductButton = UIBarButtonItem(title: "New Product", style: .plain, target: self, action: #selector(newProdduct))
        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: true)

    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.toEditCategory, sender: self)
    }
    
    @objc func newProdduct() {
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Editing Products, products, viene de ProductsVC, por eso esta instanciado
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.toAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.toAddEditProduct {
            
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.toEditCategory {
            
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }

}
