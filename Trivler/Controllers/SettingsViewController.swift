//
//  SettingsViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/25/21.
//

import UIKit
import JellyGif

class SettingsViewController: UIViewController {
    
     // IB Outlets
    @IBOutlet weak var numberQuestions: UILabel!
    @IBOutlet weak var timePerQuestion: UILabel!
    @IBOutlet weak var questionSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    var catName: String?
    
    let networkMonitor = NetworkMonitor()
    let sharedTriviaInfo = TriviaInfo.shared
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = sharedTriviaInfo.categoryName
        
        sharedTriviaInfo.categoryColor = sharedTriviaInfo.categoriesColors[sharedTriviaInfo.categoryName!]
        
        networkMonitor.delegate = self
        networkMonitor.startMonitoring()
        
        if let safeColor = TriviaInfo.shared.categoryColor {
            navigationController?.navigationBar.barTintColor = safeColor
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQuizButton.layer.cornerRadius = startQuizButton.frame.size.height/2
        startQuizButton.layer.masksToBounds = true
        
        let numberOfQuestions = TriviaInfo().numberOfQuestions
        let timeForQuestion = TriviaInfo().timeForQuestion
        
        numberQuestions.text = String(numberOfQuestions) 
        timePerQuestion.text = String(timeForQuestion)
        
        timeSlider.value = Float(timeForQuestion)
        questionSlider.value = Float(numberOfQuestions)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 119/255, green: 172/255, blue: 241/255, alpha: 0.85)
        errorMessageLabel.isHidden = true
        
        networkMonitor.stopMonitoring()
    }
    
    @IBAction func questionSliderChanged(_ sender: UISlider) {
        
        sharedTriviaInfo.numberOfQuestions = Int(sender.value)
        numberQuestions.text = String(sharedTriviaInfo.numberOfQuestions)
        
    }
    
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        
        sharedTriviaInfo.timeForQuestion = Int(sender.value)
        timePerQuestion.text = String(sharedTriviaInfo.timeForQuestion)
        
    }
    
    @IBAction func startQuizClicked(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "SettingsToCountdown", sender: self)
        
    }
    
}

extension SettingsViewController: NetworkMonitorDelegate {
    
    func connectedToInternet() {
        stackViewTopConstraint.constant = 29
        errorMessageLabel.isHidden = true
        startQuizButton.isEnabled = true
    }
    
    func notConnectedToInternet() {
        
        stackViewTopConstraint.constant = 50
        errorMessageLabel.isHidden = false
        startQuizButton.isEnabled = false
        
        
        let errorMessage = "No internet connection. Please try again later "
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -5.0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        
        let fullString = NSMutableAttributedString(string: errorMessage)
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        
        
        errorMessageLabel.attributedText = fullString
        
    }
    
}
