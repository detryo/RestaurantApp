//
//  CheckoutVC.swift
//  Restaurant
//
//  Created by Cristian Sedano Arenas on 13/07/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckoutVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shippingMethodButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var paymentContext: STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
    }
    
    func setupPaymentInfo() {
        
        subTotalLabel.text = stripeCart.subTotal.pennisToFormatterCurrency()
        processingFeeLabel.text = stripeCart.processingFee.pennisToFormatterCurrency()
        shippingCostLabel.text = stripeCart.shippingFees.pennisToFormatterCurrency()
        totalLabel.text = stripeCart.total.pennisToFormatterCurrency()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Identifiers.cartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.cartItemCell)
    }
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .name
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: stripeAPI)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = stripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    @IBAction func placeOrderButton(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
}

extension CheckoutVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stripeCart.cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cartItemCell, for: indexPath) as? CartItemCell {
            
            let product = stripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension CheckoutVC: CartItemDelegate {
    
    func removeItem(product: Product) {
        stripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        setupPaymentInfo()
        paymentContext.paymentAmount = stripeCart.total
    }
}
// MARK: - STPPaymentContextDelegate
extension CheckoutVC: STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
         // Updating the selected payment method
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
        // Updating the selected shipping method
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodButton.setTitle(shippingMethod.label, for: .normal)
            stripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setupPaymentInfo()
        } else {
            shippingMethodButton.setTitle("Select Method", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
        activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        // Item potency key
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let data: [String: Any] = ["total_amount": stripeCart.total,
                                   "customer_id": UserService.user.stripeID,
                                   "payment_method_id": paymentResult.paymentMethod?.stripeId ?? "",
                                   "idempotency": idempotency]
        
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", message: "Unable to make charge.")
                completion(STPPaymentStatus.error, error)
                return
            }
            
            stripeCart.clearCart()
            self.tableView.reloadData()
            self.setupPaymentInfo()
            completion(.success, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        
        activityIndicator.stopAnimating()
        
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
            
        case .success:
            title = "Success"
            message = "Thanks you for your purchase"
            
        case .userCancellation:
            return
            
        @unknown default:
            fatalError()
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedex = PKShippingMethod()
        fedex.amount = 5.00
        fedex.label = "Fedex"
        fedex.detail = "Arrives Tomorrow"
        fedex.identifier = "fedex"
        
        if address.country == "GB" {
            completion(.valid, nil, [upsGround, fedex], fedex)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    }
}
