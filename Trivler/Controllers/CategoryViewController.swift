//
//  CategoryViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/21/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var previousCategory: UIButton?
    var catName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryButtons.forEach { $0.layer.cornerRadius = 10 }
        self.categoryButtons.forEach { $0.layer.masksToBounds = true }
        
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Home"
    }
    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        
        nextButton.isEnabled = true
        
        previousCategory?.layer.borderWidth = 0
        
        
        sender.layer.borderWidth = 5
        sender.layer.borderColor = .init(red: 84/255, green: 117/255, blue: 245/255, alpha: 1)
        
        // Include sound recording here
        
        sender.layer.masksToBounds = true
        
        previousCategory = sender
        
        categoryName = (sender.titleLabel?.text)!
        
        print(categoryName!)
    }
    
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "CategoriesToSettings", sender: self)
        
    }
    
}
