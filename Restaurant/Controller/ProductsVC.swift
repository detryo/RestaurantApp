//
//  ProductVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 29/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var category: Category!
    
    var listener : ListFormatter!
    var database : Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        database = Firestore.firestore()
        setupTableView()
        setupQuery()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.productCell, bundle: nil),
                           forCellReuseIdentifier: Identifiers.productCell)
    }

    func setupQuery() {
        
        listener = database.products(category: category.id).addSnapshotListener({ (snap, error) in
                    
                if let error =  error {
                    debugPrint(error.localizedDescription)
                }
                    
                snap?.documentChanges.forEach({ (change) in
                        
                    let data = change.document.data()
                    let product = Product.init(data: data)
                    
                    switch change.type {
                    case .added:
                        return self.onDocumentAdded(change: change, product: product)
                    case .modified:
                        return self.onDocumentModified(change: change, product: product)
                    case .removed:
                        return self.onDocumentRemoved(change: change)
                    }
                })
                    
            }) as? ListFormatter
        }
    }

extension ProductsVC: UITableViewDataSource, UITableViewDelegate {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        
        if change.oldIndex == change.newIndex {
            // Item changed, but remined in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            
        } else {
            // the itme changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.productCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        
        viewController.product = selectedProduct
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
