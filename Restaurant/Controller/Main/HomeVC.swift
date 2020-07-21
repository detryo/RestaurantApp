//
//  HomeVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 23/06/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeVC: UIViewController {
    // Oulets
    @IBOutlet weak var loginOutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    var categories = [Category]()
    var selectedCategory: Category!
    var database: Firestore!
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()

        database = Firestore.firestore()
        setupCollectionView()
        setupInitialAnonymousUser()
        setupNavigationBar()
    }
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.categoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.categoryCell)
    }
    
    func setupInitialAnonymousUser() {
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, viewController: self)
                    debugPrint(error)
                }
            }
        }
    }
    
    func setupNavigationBar() {
        
        guard let font = UIFont(name: "futura", size: 24) else { return }
        
        navigationController?.navigationBar.titleTextAttributes = [
                                                                    NSAttributedString.Key.foregroundColor : UIColor.white,
                                                                    NSAttributedString.Key.font : font]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setCategoriesListener()
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutButton.title = "Logout"
            
           if UserService.userListener == nil {
               UserService.getCurrentUser()
           }
            
        } else {
            loginOutButton.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    func setCategoriesListener() {
        
        listener = database.categories.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.login, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.loginVC)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.toFavorites, sender: self)
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
                
                if user.isAnonymous {
                    presentLoginController()
                } else {
                    do {
                        try Auth.auth().signOut()
                        UserService.logoutUser()
                        
                        Auth.auth().signInAnonymously { (result, error) in
                            if let error = error {
                                Auth.auth().handleFireAuthError(error: error, viewController: self)
                                debugPrint(error)
                            }
                            self.presentLoginController()
                        }
                    } catch {
                        Auth.auth().handleFireAuthError(error: error, viewController: self)
                        debugPrint(error)
                    }
                }
            }
        }

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Functions Document Change
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            // Item changed, but remained in the same position
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0),
                                    to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex )
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    // MARK: CollectionView DataSource and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.categoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width  - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.toProductsVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.toProductsVC {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                
            } else if segue.identifier == Segues.toFavorites {
                
                if let destination = segue.destination as? ProductsVC {
                    
                    destination.category = selectedCategory
                    destination.showFavorites = true
                }
            }
        }
    }
}
