//
//  Product.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 29/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {

    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageURL: String
    var timeStamp: Timestamp
    
    // init creado para el AddEditProducts.swift
    init(name: String, id: String, category: String, price: Double,
         productDescription: String, imageURL: String, timeStamp: Timestamp = Timestamp()) {
        
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageURL = imageURL
        self.timeStamp = timeStamp
    }
    
    // Usamos la misma referencia que en Firebase
    init(data : [String : Any ] ) {
        
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    // Usamos la misma referencia que en Firebase, pero para el AddEditCategory.swift
    static func modelToData(product: Product) -> [String: Any] {
        
        let data: [String : Any] = ["name" : product.name,
                                    "id" : product.id,
                                    "category" : product.category,
                                    "price" : product.price,
                                    "productDescription" : product.productDescription,
                                    "imageURL" : product.imageURL,
                                    "timeStamp" : product.timeStamp ]
        return data
    }
}

extension Product: Equatable {
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
