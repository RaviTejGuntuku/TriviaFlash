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
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet var tappableView: UIView!
    
    var numberCorrect: Int?
    var totalQuestions: Int?
    
    var advice: String?
    var animationView: AnimationView?
    var shouldDisplayConfetti: Bool = false
    
    let sharedTriviaInfo = TriviaInfo.shared
    
    var percentage: Int?
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
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
        
        homeButton.layer.cornerRadius = 15
        homeButton.layer.masksToBounds = true
        
        retryButton.layer.cornerRadius = 15
        retryButton.layer.masksToBounds = true
        
        shareButton.layer.cornerRadius = 15
        shareButton.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedScreen(_:)))
        
        tappableView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func tappedScreen(_ sender: UITapGestureRecognizer) {
        
        print("Tapped view")
        
        if shouldDisplayConfetti {
            animationView?.stop()
            presentConfetti()
            
        }
        
    }
    
    func getAdvice(numberQuestionsCorrect: Int, numberQuestions: Int) -> String {
        
        percentage = Int((Double(numberQuestionsCorrect) / Double(numberQuestions)) * 100)
        
        switch percentage! {
        case 80...100:
            shouldDisplayConfetti = true
            return "Wow, you are a trivia wiz! You seem to know a lot of random facts! 👍"
        case 50...79:
            return "Not bad - maybe you should spend a bit more time on Wikipedia, though."
        case 0...49:
            return "Hey! You definitely need to refresh your knowledge on this topic."
        default:
            return "Something went wrong"
        }
    }
    
    func presentConfetti() {
        
        animationView = .init(name: "another_another_confetti")
        animationView!.frame = view.bounds

        // 3. Set animation content mode

        animationView?.contentMode = .scaleAspectFill

        // 4. Set animation loop mode

        animationView?.loopMode = .playOnce

        // 5. Adjust animation speed

        animationView?.animationSpeed = 1.0

        view.addSubview(animationView!)
        view.sendSubviewToBack(animationView!)
        
        // 6. Play animation

        animationView?.play()
        
    }
    
    
    
    @IBAction func homeButtonClicked(_ sender: UIButton) {
        
        sharedTriviaInfo.resetVariables()
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func shareButtonClicked(_ sender: UIButton) {
        
        var triviaCategory: String { 
            if sharedTriviaInfo.categoryName! != "Random" { return sharedTriviaInfo.categoryName!}
            else { return "" }
        }
        
        let items = ["Hey! Try beating my \(triviaCategory) trivia score of \(percentage!)% by downloading the Trivler App!"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    
    @IBAction func retryButton(_ sender: UIButton) {
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CountdownViewController") as! CountdownViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
