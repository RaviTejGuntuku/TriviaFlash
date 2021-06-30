//
//  SettingsViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/25/21.
//

import UIKit

class SettingsViewController: UIViewController {
     // IB Outlets
    @IBOutlet weak var numberQuestions: UILabel!
    @IBOutlet weak var timePerQuestion: UILabel!
    @IBOutlet weak var questionSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var startQuizButton: UIButton!
    
    var catName: String?
    
    var categoriesColors: [String: UIColor] = [
        "Random": UIColor(red: 176/255, green: 193/255, blue: 201/255, alpha: 1),
        "Computers": UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1),
        "Art": UIColor(red: 255/255, green: 22/255, blue: 22/255, alpha: 1),
        "History": UIColor(red: 178/255, green: 153/255, blue: 119/255, alpha: 1),
        "Math": UIColor(red: 155/255, green: 205/255, blue: 222/255, alpha: 1),
        "Science": UIColor(red: 0/255, green: 128/255, blue: 55/255, alpha: 1),
        "Sports": UIColor(red: 254/255, green: 145/255, blue: 77/255, alpha: 1),
        "Entertainment": UIColor(red: 140/255, green: 82/255, blue: 255/255, alpha: 1)
    ]
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = categoryName
        
        categoryColor = categoriesColors[categoryName!]
        
        
        if let safeColor = categoryColor {
            navigationController?.navigationBar.barTintColor = safeColor
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQuizButton.layer.cornerRadius = startQuizButton.frame.size.height/2
        startQuizButton.layer.masksToBounds = true
        
        questionSlider.value = Float(numberOfQuestions)
        timeSlider.value = Float(timeForQuestion)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 119/255, green: 172/255, blue: 241/255, alpha: 0.85)
    }
    
    @IBAction func questionSliderChanged(_ sender: UISlider) {
        
        numberOfQuestions = Int(sender.value)
        numberQuestions.text = String(numberOfQuestions)
        
    }
    
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        
        timeForQuestion = Int(sender.value)
        timePerQuestion.text = String(timeForQuestion)
        
    }
    
    @IBAction func startQuizClicked(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "SettingsToCountdown", sender: self)
        
    }
    
}
