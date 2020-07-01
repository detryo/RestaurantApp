//
//  ProductVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 29/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var product = [Product]()
    var category: Category!

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    



}
