//
//  QuizViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/27/21.
//


import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet var options: [UIButton]!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeRemainingCircle: PlainCircularProgressBar!
    
    let fadeTime: Double = 0.5
    
    var questionNumber: Int = 1
    var triviaQuestions: [Question]?
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.displayQuestion(question: (self.triviaQuestions?[self.questionNumber - 1].question)!)
        self.changeOptions(answerChoices: (self.triviaQuestions?[self.questionNumber - 1].options)!)
        
        if let safeName = categoryName {
            self.title = "\(safeName) Trivia!"
        }
        
        if let safeColor = categoryColor {
            navigationController?.navigationBar.barTintColor = safeColor
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 119/255, green: 172/255, blue: 241/255, alpha: 0.85)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        var timeView = UIView()
//        timeView.frame = CGRect(center: CGPoint(x: 50, y: 50), size: CGSize(width: 20, height: 20))
//        timeView.backgroundColor = .green
//        view.addSubview(timeView)
        
        timeRemainingCircle.color = .green
        
        progressBar.layer.cornerRadius = 5
        progressBar.layer.masksToBounds = true
        
        progressBar.layer.sublayers?[1].cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        
        self.options.forEach { $0.layer.cornerRadius = $0.frame.size.height * 20/64 }
        self.options.forEach { $0.layer.masksToBounds = true }
        
        self.options.forEach { $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)}
        self.options.forEach { $0.titleLabel?.textAlignment = .left}
        self.options.forEach { $0.titleLabel?.textColor = .white}
        self.options.forEach { $0.titleLabel?.adjustsFontSizeToFitWidth = true}
        self.options.forEach { $0.titleLabel?.translatesAutoresizingMaskIntoConstraints = false}
        
        questionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        questionLabel.textAlignment = .left
        questionLabel.textColor = .white
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @IBAction func answerClicked(_ sender: UIButton, forEvent event: UIEvent) {
        
        let touches = event.touches(for: sender)
        let touch = touches?.first
        let touchPosition = touch?.location(in: view)
        
        let iconName: String
        let buttonColor: UIColor
        
        let animationTime = 1.5
        
        let chosenAnswer = sender.titleLabel!.text!
//        print(chosenAnswer)
//
//        print(triviaQuestions![questionNumber - 1].correctAnswer)
        
        // Checks whether answer is correct or not
        if triviaQuestions![questionNumber - 1].correctAnswer == chosenAnswer {
            iconName = "checkmark"
            buttonColor = .green
        } else {
            iconName = "xmark"
            buttonColor = .red
        }
        
        displayIcon(iconName, location: touchPosition!, seconds: animationTime)
        changeButton(sender, bgColor: buttonColor, seconds: animationTime)
        
        questionNumber += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime - fadeTime) {
            self.displayQuestion(question: (self.triviaQuestions?[self.questionNumber - 1].question)!, transitionTime: 0.5)
            self.changeOptions(answerChoices: (self.triviaQuestions?[self.questionNumber - 1].options)!)
        }
        
    }
    
    @IBAction func exitButtonClicked(_ sender: UIBarButtonItem) {
        
        let refreshAlert = UIAlertController(title: "Quiz Paused", message: "Do you want to continue playing or exit the quiz?", preferredStyle: UIAlertController.Style.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { (action: UIAlertAction!) in
          
            // Ensure that timer is still running, if needed
            
          }))
        
        refreshAlert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (action: UIAlertAction!) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
        
            
            // Reset Quiz Variables
            categoryName = nil
            categoryColor = nil
            
            numberOfQuestions = 10
            timeForQuestion = 15
            
          }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func displayQuestion(question: String, transitionTime: Double? = 0.0) {

        self.questionLabel.slideInFromRight(TimeInterval(transitionTime!))
        self.questionLabel.text = question
        
    }
    
    func changeOptions(answerChoices: [String]) {
        
        for i in 0...answerChoices.count - 1 {
//            options[i].titleLabel?.text = answerChoices[i]
            
            options[i].setTitle(answerChoices[i], for: .normal)
        }
        
        
    }
    
    func changeButton(_ button: UIButton, bgColor: UIColor, seconds: Double? = 2.0) {
        
        button.layer.borderWidth = 3.0
        button.layer.borderColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        button.backgroundColor = bgColor
        
        self.options.forEach { $0.isEnabled = false }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds! - fadeTime) {
            
            self.options.forEach { $0.isEnabled = true }
            button.layer.borderWidth = 0.0
            button.backgroundColor = UIColor(red: 246/255, green: 223/255, blue: 235/255, alpha: 0.5)

        }
        
    }
    
    func displayIcon(_ sysName: String, location: CGPoint, seconds: Double? = 2.0) {
        
        let image = UIImage(systemName: sysName)
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(center: location, size: CGSize(width: 33, height: 33))
        view.addSubview(imageView)
        
        UIView.animate(withDuration: TimeInterval(seconds! - 0.5), delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
               imageView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2) // Scale your image
         }) { (finished) in
            UIView.animate(withDuration: self.fadeTime, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                imageView.alpha = 0.0
            }) { (finished) in imageView.removeFromSuperview()}
        }
        
    }
    
}

//@IBDesignable
//class PlainHorizontalProgressBar: UIView {
//    @IBInspectable var color: UIColor? = .gray
//
//    override func draw(_ rect: CGRect) {
//        let backgroundMask = CAShapeLayer()
//        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
//        layer.mask = backgroundMask
//    }
//
//}
