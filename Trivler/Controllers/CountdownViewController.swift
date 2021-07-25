//
//  CountdownViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/27/21.
//

import UIKit
import Lottie

enum SegueStatus {
    case satisfied
    case recievedData
    case waitingForData
    case notConnectedToInternet
    case failedWithError
}

class CountdownViewController: UIViewController {

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var timeRemaining: Int = 3 {
        didSet {
            if timeRemaining > 0 { checkSegue() }
        }
    }
    var timer: Timer!
    
    var triviaManager = TriviaManager()
    
    var networkMonitor = NetworkMonitor()
    
    var triviaQuestions: [Question]?
    var appError: Error?
    
    let errorMessage = "Something went wrong. Please try again later."
    
    var segueStatus: SegueStatus = .waitingForData
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triviaManager.delegate = self
        
//        errorMessageLabel.isHidden = false
        
        errorMessageLabel.isHidden = true
        
        networkMonitor.startMonitoring()
        networkMonitor.delegate = self
        
//        loadingDots = .init(name: "loading-dots")
//        
//        loadingDots.contentMode = .scaleAspectFit
//        
//        loadingDots.loopMode = .loop
//        
//        loadingDots.animationSpeed = 1.0
        
        zoomInText(text: String(timeRemaining))
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        
    }
    
    func zoomInText(text: String, completion: @escaping (() -> Void) = {  }) {
        
        countdownLabel.text = text
        
        countdownLabel.font = countdownLabel.font.withSize(150)
        
        countdownLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.0, animations: {
            self.countdownLabel.transform = .identity
        }) {(finished) in
            completion()
        }
        
    }
    
    @objc func step() {
        
        if timeRemaining > 0 {
            
            timeRemaining -= 1
            
            if timeRemaining >= 1 {
                zoomInText(text: String(timeRemaining))
            } else {
                zoomInText(text: "Go!") {
                    self.checkSegue()
                }
            }
            
        } else {
            timer.invalidate()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func checkSegue() {
        
        if segueStatus == .recievedData && timer.isValid == false {
            segueStatus = .satisfied
            
            self.performSegue(withIdentifier: "CountdownToQuiz", sender: self)
            
        } else if segueStatus == .waitingForData && timer.isValid == false {
            
            // Tell user that fetching questions is taking longer than expected ...
            
            let errorMessage = "Question fetching is taking longer than expected. Please wait"
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "exclamationmark.arrow.triangle.2.circlepath")?.withTintColor(.white)
            imageAttachment.bounds = CGRect(x: 0, y: -5.0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            
            let fullString = NSMutableAttributedString(string: errorMessage)
            fullString.append(NSAttributedString(attachment: imageAttachment))
            
            errorMessageLabel.attributedText = fullString
            errorMessageLabel.isHidden = false
            
        } else if segueStatus == .notConnectedToInternet {
            
            // Using the error message label, inform user about internet connectivity 
            
            let errorMessage = "No internet connection. Please try again later "
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "wifi.exclamationmark")?.withTintColor(.white)
            imageAttachment.bounds = CGRect(x: 0, y: -5.0, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            
            
            let fullString = NSMutableAttributedString(string: errorMessage)
            fullString.append(NSAttributedString(attachment: imageAttachment))
            
            errorMessageLabel.attributedText = fullString
            errorMessageLabel.isHidden = false
            
        } else if segueStatus == .failedWithError {
           
            // In an AlertViewController, display that something went wrong and maybe provide mechanism for bug reporting.
            
            let errorAlert = UIAlertController(title: "Error", message: "Sorry for the inconvenience; something went wrong while trying to fetch the quiz questions. Be sure to take a screenshot of this alert and report the error below to the developer of the app: \n \(appError!)", preferredStyle: UIAlertController.Style.alert)
            
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(errorAlert, animated: true, completion: nil)
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CountdownToQuiz" {
            let destinationVC = segue.destination as! QuizViewController
            destinationVC.triviaQuestions = triviaQuestions
        }
        
    }

}


extension CountdownViewController: TriviaManagerDelegate {
    
    func didGetQuestions(_ triviaManager: TriviaManager, triviaModel: TriviaModel) {
        
        DispatchQueue.main.async {
            self.triviaQuestions = triviaModel.questions
            self.segueStatus = .recievedData
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        segueStatus = .failedWithError
        appError = error
        print(appError!)
    }
}

extension CountdownViewController: NetworkMonitorDelegate {
    
    func connectedToInternet() {
        errorMessageLabel.isHidden = true
        triviaManager.fetchQuestions()
        checkSegue()
    }
    
    func notConnectedToInternet() {
        segueStatus = .notConnectedToInternet
        errorMessageLabel.isHidden = false
        checkSegue()
    }
    
}
