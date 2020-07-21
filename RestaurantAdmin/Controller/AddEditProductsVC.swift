//
//  AddEditProductsVC.swift
//  RestaurantAdmin
//
//  Created by Cristian Sedano Arenas on 02/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var productPriceText: UITextField!
    @IBOutlet weak var productDescTextView: UITextView!
    @IBOutlet weak var productImageView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addProductButton: RoundedButton!
    
    var productToEdit : Product?
    var selectedCategory: Category!
    
    var name = ""
    var price = 0.0
    var productDescription = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        productImageView.isUserInteractionEnabled = true
        productImageView.clipsToBounds = true
        productImageView.addGestureRecognizer(tap)
            
        if let product = productToEdit {
                
            productNameText.text = product.name
            productDescTextView.text = product.productDescription
            productPriceText.text = String(product.price)
            addProductButton.setTitle("Save Changes", for: .normal)
                
            if let url = URL(string: product.imageURL) {
                    
                productImageView.contentMode = .scaleAspectFill
                productImageView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePicker()
    }
    
    func uploadImageThenDocument() {
        
        guard let image = productImageView.image,
            let name = productNameText.text, name.isNotEmpty,
            let description = productDescTextView.text, description.isNotEmpty,
            let priceString = productPriceText.text,
            let price = Double(priceString) else {
                
                simpleAlert(title: "Missing Fields", message: "Please fill out required fields.")
                return
        }
        
        self.name = name
        self.price = price
        self.productDescription = description
        
        activityIndicator.startAnimating()
        
        // upload image to cloud storage
        // Step 1: Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create an storage image reference -> A location in Firestorage for it to be stored.
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        
        // Step 3: Set the meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // Step 4: Upload the data.
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                
                self.hadlerError(error: error, message: "Unable to upload image.")
                return
            }
            
            // Step 5: Once the image is uploaded, retrieve the download URL.
            imageRef.downloadURL { (url, error) in
                
                if let error = error {
                    
                    self.hadlerError(error: error, message: "Unable to download url")
                    return
                }
                
                guard let url = url else { return }
                print(url)
                
                // Step 6: Upload new Product document to the Firestore categories collection.
                self.uploadDocument(url: url.absoluteString)
                
            }
        }
    }
    
    func uploadDocument(url: String) {
        
        var docRef: DocumentReference!
        var product = Product.init(name: name, id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imageURL: url)
        
        if let productToEdit = productToEdit {
            // we are editing product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
            
        } else {
            // we are adding new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            
            if let error = error {
                
                self.hadlerError(error: error, message: "Unable to upload Firestore document.")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func hadlerError(error: Error, message: String) {
        
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", message: message)
        activityIndicator.stopAnimating()
    }

    @IBAction func addProductClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
}

extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imgae = info[.originalImage] as? UIImage else { return }
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = imgae
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

