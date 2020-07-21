//
//  StripeAPI.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 16/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let stripeAPI = _StripeAPI()

class _StripeAPI: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let data = [ "stripe_version": apiVersion, "customer_id": UserService.user.stripeID]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            completion(key,nil)
        }
    }
}
