//
//  User.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 04/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import Foundation

// estructura creada para que los usuarios marquen
// sus productos favoritos y crear nuevos usuarios
struct User {
    
    var id: String
    var email: String
    var userName: String
    var stripeID: String
    
    init(id: String = "", email: String = "", userName: String = "", stripeID: String = "") {
        self.id = id
        self.email = email
        self.userName = userName
        self.stripeID = stripeID
    }
    
    // Create init that we use get the data back from Firestore
    // in which we are going to convert a dictionary, into our instance
    // of our user want to say init
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data[email] as? String ?? ""
        userName = data["userName"] as? String ""
        stripeID = data["stripeID"] as? String ""
    }
    
    // Create a function where we take an instant of this model
    // and convert in to a dictionary, to be uploaded as a Firestore
    // document
    static func modelToData(user: User) -> [String: Any] {
        let data: [String: Any] = [ "id": user.id,
                                    "email": user.email,
                                    "userName": user.userName,
                                    "stripeID": user.stripeID ]
        return data
    }
}
