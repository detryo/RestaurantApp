//
//  HomeVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 23/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentLoginController()
    }

    func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.login, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: StoryboardID.loginVC)
        present(controller, animated: true, completion: nil)
    }
}
