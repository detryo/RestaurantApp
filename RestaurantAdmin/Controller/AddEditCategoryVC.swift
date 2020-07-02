//
//  AddEditCategoryVC.swift
//  RestaurantAdmin
//
//  Created by Cristian Sedano Arenas on 02/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var categoryNameText: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addcategoryButton: UIButton!
    
    var categoryToEdit: Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        // if we are editing categoryToEdit will not be != nil
        if let category = categoryToEdit {
            
            categoryNameText.text = category.name
            addcategoryButton.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imageURL) {
                
                categoryImage.contentMode = .scaleAspectFill
                categoryImage.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePicker()
    }
    
    
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        uplodadImageThenDocument()
    }
    // MARK: Upload Image and Name to Firebase
    func uplodadImageThenDocument() {
        
        guard let image = categoryImage.image,
              let categoryName = categoryNameText.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", message: "Must add category image and name")
                return
        }
        
        activityIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("÷categoryImages/\(categoryName).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handlerError(error: error, message: "Unable to upload image")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                
                if let error = error {
                    self.handlerError(error: error, message: "Unable to upload image")
                    return
                }
                
                guard let url = url else { return }
                print(url)
                self.uplodadDocuments(url: url.absoluteString)
            }
        }
    }
    
    func uplodadDocuments(url: String) {
        
        var docRef: DocumentReference!
        var category = Category.init(name: categoryNameText.text!, id: "", imageURL: url, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
             // we are editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            // new category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.modelToData(category: category)
        
        docRef.setData(data, merge: true) { (error) in
            
            if let error = error {
                self.handlerError(error: error, message: "Unable to upload new Category to Firebase")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handlerError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: message)
        self.activityIndicator.stopAnimating()
    }
}

// MARK: ImagePicker Delegate and NavigationController delegate
extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
