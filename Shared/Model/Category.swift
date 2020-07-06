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
    
    // init creado para el AddEditCategory.swift
    init(name: String, id: String, imageURL: String, isActive: Bool = true, timeStamp: Timestamp = Timestamp()) {
        
        self.name = name
        self.id = id
        self.imageURL = imageURL
        self.isActive = isActive
        self.timeStamp = timeStamp
    }
    
    // Usamos la misma referencia que en Firebase
    init(data : [String : Any ] ) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    // Usamos la misma referencia que en Firebase, pero para el AddEditCategory.swift
    static func modelToData(category: Category) -> [String : Any] {
        
        let data : [String : Any] = [ "name" : category.name,
                                      "id" : category.id,
                                      "imageURL" : category.imageURL,
                                      "isActive" : category.isActive,
                                      "timeStamp" : category.timeStamp]
        return data
    }
}
