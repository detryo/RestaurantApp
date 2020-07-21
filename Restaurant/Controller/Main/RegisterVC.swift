//
//  RegisterVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 23/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Firebase

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
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let passwordText = passwordTextField.text else { return }
        
        //if we have started typing in the confirm pass text field
        if textField == confirmPassTextField {
            passwordCheckImage.isHidden = false
            confirmPassCheckImage.isHidden = false
        } else {
            // clear text field
            if passwordText.isEmpty {
                passwordCheckImage.isHidden = true
                confirmPassCheckImage.isHidden = true
                confirmPassTextField.text = ""
            }
        }
        
        // Make it so when the password match, the checkmarks turn green
        if passwordTextField.text == confirmPassTextField.text {
            passwordCheckImage.image = UIImage(named: AppImages.greenCheck)
            confirmPassCheckImage.image = UIImage(named: AppImages.greenCheck)
        } else {
            passwordCheckImage.image = UIImage(named: AppImages.redCheck)
            confirmPassCheckImage.image = UIImage(named: AppImages.redCheck)
        }
    }
    // Registramos nuevos usuarios y tambien el usuario anonimo puede registrarse
    @IBAction func registerClicked(_ sender: UIButton) {
        // Mensajes de error
        guard let email = emailTextField.text, email.isNotEmpty,
              let password = passwordTextField.text, password.isNotEmpty,
              let userName = userNameTextField.text, userName.isNotEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all fields")
                return
        }
        // Mensajes de error
        guard let confirmPass = confirmPassTextField.text, confirmPass == password else {
            simpleAlert(title: "Error", message: "Password do not match")
            return
        }
        
        activityIndicator.startAnimating()
        // Creamos el registro de usuario y el del anonimo
        guard let authUser = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        authUser.link(with: credential) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, viewController: self)
                return
            }
            
            //Firebase Authenticated user result
            guard let fireUser = result?.user else { return }
            let artUser = User.init(id: fireUser.uid, email: email, userName: userName, stripeID: "")
            
            // Upload to Firestore
            self.createFirestoreUser(user: artUser)
        }
    }
    
    func createFirestoreUser(user : User) {
            // Step 1: Create document reference
            let newUserRef = Firestore.firestore().collection("users").document(user.id)
            
            // Step 2: Create model data
            let data = User.modelToData(user: user)
            
            // Step 3: Upload to Firestore
            newUserRef.setData(data) { (error) in
                
                if let error = error {
                    
                    Auth.auth().handleFireAuthError(error: error, viewController: self)
                    debugPrint("Unable to upload new user document \(error.localizedDescription)")
                    return
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
