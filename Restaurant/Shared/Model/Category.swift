//
//  Category.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 29/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import Foundation
import FirebaseFirestore

// creamos la structura con los mismos parametros que en Firebase
struct Category {

    var name: String
    var id : String
    var imageURL : String
    var isActive : Bool = true
    var timeStamp : Timestamp
    
    // Usamos la misma referencia que en Firebase
    init(data : [String : Any ] ) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
}
