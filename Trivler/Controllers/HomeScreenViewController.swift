//
//  ViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/20/21.
//

import UIKit
import Network

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tapToStartLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    let networkMonitor = NetworkMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkMonitor.delegate = self
        networkMonitor.startMonitoring()
        
        tapToStartLabel.text = ""
        
        showTypingText(text: "Tap To Start")
        
    }
    
    func showTypingText(text: String, interval: Double = 0.1, delayAtBeginning: Double = 0.1) {
        
        var charIndex: Int = 0
        tapToStartLabel.text = ""
        
        for letter in text {
            Timer.scheduledTimer(withTimeInterval: (interval * Double(charIndex)) + delayAtBeginning, repeats: false, block: { (timer) in
                self.tapToStartLabel.text?.append(letter)
            })
            
            charIndex += 1
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 119/255, green: 172/255, blue: 241/255, alpha: 1.0)
        
        networkMonitor.stopMonitoring()
        
    }


}

extension HomeScreenViewController: NetworkMonitorDelegate {
    
    func connectedToInternet() {
        
        tapGesture.isEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func notConnectedToInternet() {
    
        let errorMessage = "No internet connection. Please try again later "
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -5.0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        
        let fullString = NSMutableAttributedString(string: errorMessage)
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.setNavigationBarHidden(false, animated: true)
        errorMessageLabel.attributedText = fullString
        tapGesture.isEnabled = false
        
    }
    
}

