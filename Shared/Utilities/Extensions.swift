//
//  Extensions.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 24/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Locale {
    static let uk = Locale(identifier: "en_GB")
}

extension Int {
    
    func pennisToFormatterCurrency() -> String {
        
        let pounds = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_GB")
        
        if let poundString = formatter.string(from: pounds as NSNumber) {
            return poundString
        }
        
        return "£0.0"
    }
}
