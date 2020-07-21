//
//  LoginVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 23/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // Recuperar contraseña
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        
        let forgotPassword = ForgotPasswordVC()
        forgotPassword.modalTransitionStyle = .crossDissolve
        forgotPassword.modalPresentationStyle = .overCurrentContext
        present(forgotPassword, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        guard let email = emailTextField.text, email.isNotEmpty,
              let password = passwordTextField.text, password.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all fields")
                return
        }
        
        activityIndicator.startAnimating()
        // Logearse directamente con el usuario
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                // Damos un mensaje de error por si falla al logearse
                Auth.auth().handleFireAuthError(error: error, viewController: self)
                self.activityIndicator.stopAnimating()
                return
            } else {
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func guestClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
