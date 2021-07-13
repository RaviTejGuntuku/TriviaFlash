//
//  ResultsViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/13/21.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    var numberCorrect: Int?
    var totalQuestions: Int? {
        didSet {
//            resetVariables()
        }
    }
    var advice: String?

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let confettiImageView = UIImageView.fromGif(frame: view.frame, resourceName: "Confetti_Edited.gif") else { return }
//         view.addSubview(confettiImageView)
//         confettiImageView.startAnimating()
//
//        confettiImageView.animationDuration = 3
//        confettiImageView.animationRepeatCount = 1
//
//        confettiImageView.animationImages = nil
        
        presentConfetti()
        
        adviceLabel.adjustsFontSizeToFitWidth = true
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let safeNumberCorrect = numberCorrect, let safeNumberQuestions = totalQuestions {
            resultLabel.text = "\(safeNumberCorrect)/\(safeNumberQuestions)"
            
            let advice = getAdvice(numberQuestionsCorrect: safeNumberCorrect, numberQuestions: safeNumberQuestions)
            
            adviceLabel.text = advice
            
            if advice == "Wow, you are a trivia wiz!" {
                presentConfetti()
            }
            
        } else {
            adviceLabel.text = "Something went wrong while processing the results! Please check later."
        }
        
        homeButton.layer.cornerRadius = homeButton.frame.size.height/2
        homeButton.layer.masksToBounds = true
        
    }
    
    func getAdvice(numberQuestionsCorrect: Int, numberQuestions: Int) -> String {
        
        let percentage: Int = Int((Double(numberQuestionsCorrect) / Double(numberQuestions)) * 100)
        
        print(percentage)
        
        switch percentage {
        case 80...100:
            return "Wow, you are a trivia wiz!"
        case 50...79:
            return "Not bad - maybe you should spend a \nbit more time on Wikipedia, though."
        case 0...49:
            return "Hey! You definitely need to refresh \nyour knowledge on this topic."
        default:
            return "Something went wrong"
        }
    }
    
    func presentConfetti() {
        guard let confettiImageView = UIImageView.fromGif(frame: view.frame, resourceName: "Confetti") else { return }
        
        view.addSubview(confettiImageView)
        confettiImageView.startAnimating()

        confettiImageView.animationDuration = 3
        confettiImageView.animationRepeatCount = 1

        confettiImageView.animationImages = nil
    }
    
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        resetVariables()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
