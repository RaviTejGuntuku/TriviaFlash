//
//  ResultsViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/13/21.
//

import UIKit
import JellyGif
import Lottie

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    var numberCorrect: Int?
    var totalQuestions: Int?
    
    var advice: String?
    var animationView: AnimationView?
    var shouldDisplayConfetti: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        presentConfetti()
        
        adviceLabel.adjustsFontSizeToFitWidth = true
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let safeNumberCorrect = numberCorrect, let safeNumberQuestions = totalQuestions {
            resultLabel.text = "\(safeNumberCorrect)/\(safeNumberQuestions)"
            
            let advice = getAdvice(numberQuestionsCorrect: safeNumberCorrect, numberQuestions: safeNumberQuestions)
            
            adviceLabel.text = advice
            
            if shouldDisplayConfetti {
                presentConfetti()
            }
            
        } else {
            adviceLabel.text = "Something went wrong while processing \nthe results! Please check later."
        }
        
        homeButton.layer.cornerRadius = homeButton.frame.size.height/2
        homeButton.layer.masksToBounds = true
        
    }
    
    func getAdvice(numberQuestionsCorrect: Int, numberQuestions: Int) -> String {
        
        let percentage: Int = Int((Double(numberQuestionsCorrect) / Double(numberQuestions)) * 100)
        
        print(percentage)
        
        switch percentage {
        case 80...100:
            shouldDisplayConfetti = true
            return "Wow, you are a trivia wiz! \nYou seem to know a lot of random facts! 👍"
        case 50...79:
            return "Not bad - maybe you should spend a \nbit more time on Wikipedia, though."
        case 0...49:
            return "Hey! You definitely need to refresh \nyour knowledge on this topic."
        default:
            return "Something went wrong"
        }
    }
    
    func presentConfetti() {
        
        animationView = .init(name: "another_another_confetti")
        animationView!.frame = view.bounds

        // 3. Set animation content mode

        animationView!.contentMode = .scaleAspectFill

        // 4. Set animation loop mode

        animationView!.loopMode = .playOnce

        // 5. Adjust animation speed

        animationView!.animationSpeed = 1.0

        view.addSubview(animationView!)
        view.sendSubviewToBack(animationView!)
        
        // 6. Play animation

        animationView!.play()
        
        
    }
    
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        resetVariables()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
