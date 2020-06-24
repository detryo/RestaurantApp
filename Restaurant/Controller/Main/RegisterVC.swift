//
//  RegisterVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 23/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordCheckImage: UIImageView!
    @IBOutlet weak var confirmPassCheckImage: UIImageView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    @IBAction func registerClicked(_ sender: UIButton) {
    }
    
}
