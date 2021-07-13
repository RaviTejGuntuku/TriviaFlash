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
    @IBOutlet weak var scoreLabel: UILabel!
    
    let fadeTime: Double = 0.5
    let animationTime: Double = 1.5
    
    var questionNumber: Int = 1
    var triviaQuestions: [Question]?
    
    var score = 0
    
    var timeRemaining: Int = timeForQuestion
    var timer: Timer!
    
    var barTimeRemaining: Float = Float(timeForQuestion)
    var barTimer: Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(questionNumber)
        
        scoreLabel.text = "Score: \(score)/\(numberOfQuestions)"
        
        self.displayQuestion(question: (self.triviaQuestions?[self.questionNumber - 1].question)!)
        self.changeOptions(answerChoices: (self.triviaQuestions?[self.questionNumber - 1].options)!)
        
        progressBar.progress = Float(questionNumber) - 1.0
        
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
        
        startTimer()
        
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
        self.options.forEach { $0.titleLabel?.numberOfLines = 2}
        self.options.forEach { $0.titleLabel?.translatesAutoresizingMaskIntoConstraints = false}
        
        questionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        questionLabel.textAlignment = .left
        questionLabel.textColor = .white
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "QuizToResults" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.numberCorrect = score
            destinationVC.totalQuestions = numberOfQuestions
            self.endTimers()
        }
        
    }
    
    @IBAction func answerClicked(_ sender: UIButton, forEvent event: UIEvent) {
        
        let touches = event.touches(for: sender)
        let touch = touches?.first
        let touchPosition = touch?.location(in: view)
        
//        let touchPositionInButton = touch?.location(in: sender)
        
//        let touchPositionInButton = (touch?.location(in: sender))!
        
        let iconName: String
        let buttonColor: UIColor
        
        let chosenAnswer = sender.titleLabel!.text!
        
        // Checks whether answer is correct or not
        if triviaQuestions![questionNumber - 1].correctAnswer == chosenAnswer {
            iconName = "checkmark"
            buttonColor = .green
            score += 1
        } else {
            iconName = "xmark"
            buttonColor = .red
            revealCorrectAnswer(animationTime: animationTime)
        }
        
        endTimers()
        
        displayIcon(iconName, location: touchPosition!, seconds: animationTime)
        changeButton(sender, bgColor: buttonColor, seconds: animationTime)
        scoreLabel.text = "Score: \(score)/\(numberOfQuestions)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime - fadeTime) {
            self.setUpForNextQuestion()
        }
        
    }
    
    @IBAction func exitButtonClicked(_ sender: UIBarButtonItem) {
        
        let refreshAlert = UIAlertController(title: "Quiz Paused", message: "Do you want to continue playing or exit the quiz?", preferredStyle: UIAlertController.Style.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Resume", style: .default, handler: { (action: UIAlertAction!) in
          
            // Ensure that timer is still running, if needed
            
          }))
        
        refreshAlert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (action: UIAlertAction!) in
            
            self.endTimers()
            resetVariables()
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
          }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func endTimers() {
        
        timer.invalidate()
        barTimer.invalidate()
        
    }
    
    func displayQuestion(question: String, transitionTime: Double? = 0.0) {
        
        questionLabel.slideInFromRight(TimeInterval(transitionTime!))
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
    
    func setUpForNextQuestion(animationTime: Double = 1.0) {
        
        questionNumber += 1
        
        UIView.animate(withDuration: animationTime, animations: {
            self.progressBar.setProgress((Float(self.questionNumber - 1)) / Float(numberOfQuestions), animated: true)
        }) { (finished) in
            if self.questionNumber - 1 < numberOfQuestions {
                
                self.startTimer()
                self.displayQuestion(question: (self.triviaQuestions?[self.questionNumber - 1].question)!, transitionTime: 0.5)
                self.changeOptions(answerChoices: (self.triviaQuestions?[self.questionNumber - 1].options)!)
                
            } else {
                UIView.animate(withDuration: animationTime, animations: {
                    self.progressBar.setProgress(1.0, animated: true)
                }) { (finished) in
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.performSegue(withIdentifier: "QuizToResults", sender: self)
                    }
                }
            }
        }

    }
    
    func startTimer() {
        
        timeRemainingCircle.color = .green
        timeRemaining = timeForQuestion
        
        barTimeRemaining = Float(timeForQuestion)
        timeRemainingLabel.text = String(timeRemaining)
        
        timeRemainingCircle.progress = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        barTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(stepBar), userInfo: nil, repeats: true)
        
    }
    
    @objc func step() {
        
        if timeRemaining > 0 {
            timeRemaining -= 1
            
            timeRemainingLabel.text = String(timeRemaining)
//            timeRemainingCircle.progress = CGFloat(barTimeRemaining) / CGFloat(timeForQuestion)
            
        } else {
            timer.invalidate()
            revealCorrectAnswer()
            setUpForNextQuestion()
        }
        
    }
    
    @objc func stepBar() {
        
        if barTimeRemaining > 0 {

            barTimeRemaining -= 0.01
            timeRemainingCircle.progress = CGFloat(barTimeRemaining) / CGFloat(timeForQuestion)

        } else {
            barTimer.invalidate()
        }
        
        if barTimeRemaining < 3 {
            timeRemainingCircle.color = .red
        }
        
    }
    
    func revealCorrectAnswer(incorrectButton: UIButton? = nil, touchCoordinates: CGPoint? = nil, animationTime: Double = 2.0) {
        
        let correctAnswerButton = getCorrectButton()
        
        var exactLocation: CGPoint
        
        if let safeButton = correctAnswerButton {
            
            exactLocation = safeButton.superview!.convert(safeButton.center, to: self.view)
            
            print(exactLocation)
            
            displayIcon("checkmark", location: exactLocation, seconds: animationTime)
            changeButton(safeButton, bgColor: .green, seconds: animationTime)
            
        } else {
            print("Could not find correct answer!")
        }
        
    }
    
    func getCorrectButton() -> UIButton? {
        
        var correctButton: UIButton?
        
        for i in 0...options.count - 1 {
            
            let optionTitleText = options[i].titleLabel!.text!
            let correctAnswer = triviaQuestions![questionNumber - 1].correctAnswer
            
            if correctAnswer == optionTitleText {
                correctButton = options[i]
            }
            
        }
        
        return correctButton
        
    }
    
}
