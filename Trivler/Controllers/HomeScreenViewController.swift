//
//  ViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/20/21.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tapToStartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapToStartLabel.text = ""
        let labelText = "Tap To Start"
        
        var charIndex: Int = 0
        
        for letter in labelText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex), repeats: false, block: { (timer) in
                self.tapToStartLabel.text?.append(letter)
            })
            
            charIndex += 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }


}

