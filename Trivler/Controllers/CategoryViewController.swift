//
//  CategoryViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/21/21.
//

import UIKit
import Network

class CategoryViewController: UIViewController {
    
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var previousCategory: UIButton?
    var catName: String?
    
    let networkMonitor = NetworkMonitor()
    
//    var isReachable: Bool { NetworkMonitor.shared.connectedToInternet }
    
    
//    var connectedToInternet: Bool = false
    
//    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        errorMessageLabel.isHidden = true
//        scrollViewTopConstraint.constant = 15
        
        networkMonitor.startMonitoring()
        self.categoryButtons.forEach { $0.layer.cornerRadius = 10 }
        self.categoryButtons.forEach { $0.layer.masksToBounds = true }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
//                
//                self.errorMessageLabel.isHidden = false
//                self.scrollViewTopConstraint.constant = 40
//                
//            })
//        }
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Home"
        
        networkMonitor.delegate = self
        
    }
    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        
        if networkMonitor.connectedToInternet {
            
            TriviaInfo.shared.categoryName = (sender.titleLabel?.text)!
            print(TriviaInfo.shared.categoryName!)
            self.performSegue(withIdentifier: "CategoriesToSettings", sender: self)
            
        } else {
            return
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkMonitor.startMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        networkMonitor.stopMonitoring()
        
    }
    
}

extension CategoryViewController: NetworkMonitorDelegate {
    
    func connectedToInternet() {
        
//        previousCategory?.layer.borderWidth = 5
        
        errorMessageLabel.isHidden = true
        scrollViewTopConstraint.constant = 15
        
        
    }
    
    func notConnectedToInternet() {
        
        let errorMessage = "No internet connection. Please try again later "
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -5.0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        
        
        let fullString = NSMutableAttributedString(string: errorMessage)
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
//        previousCategory?.layer.borderWidth = 0
        
        errorMessageLabel.attributedText = fullString
        
        
        errorMessageLabel.isHidden = false
        
        scrollViewTopConstraint.constant = 40
        
    }
    
}
