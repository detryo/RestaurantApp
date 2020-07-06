//
//  UserService.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 06/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    // Variable
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let database = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var favoriteListener : ListenerRegistration? = nil
    
    var isGuest : Bool {
    
        guard let authUser = auth.currentUser else { return true }
        
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        
        guard let authUser = auth.currentUser else { return }
        let userRef = database.collection("users").document(authUser.uid)
        
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
            print(self.user)
        })
        
        let faveRef = userRef.collection("favorites")
        
        favoriteListener = faveRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favoriteListener?.remove()
        favoriteListener = nil
        user = User()
        favorites.removeAll()
    }
}