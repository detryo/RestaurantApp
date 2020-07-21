//
//  Constants.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 24/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let main = "Main"
    static let login = "Login"
}

struct StoryboardID {
    static let loginVC = "LoginVC"
}

struct AppImages {
    
    static let greenCheck = "green_check"
    static let redCheck = "red_check"
    static let placeholder = "placeholder"
    static let emptyStar = "empty_star"
    static let filledStar = "filled_star"
}

struct AppColor {
    static let blue = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    static let red = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    static let offWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct Identifiers {
    
    static let categoryCell = "CategoryCell"
    static let productCell = "ProductCell"
    static let cartItemCell = "CartItemCell"
}

struct Segues {
    static let toProductsVC = "toProductsVC"
    static let toAddEditCategory = "toAddEditCategory"
    static let toEditCategory = "toEditCategory"
    static let toAddEditProduct = "toAddEditProduct"
    static let toFavorites = "toFavorites"
}
