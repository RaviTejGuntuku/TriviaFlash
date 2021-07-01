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
    
    var correctAnswer = "Option 1"
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        self.options.forEach { $0.layer.cornerRadius = 20 }
        self.options.forEach { $0.layer.masksToBounds = true }
        
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
        
        
        // Checks 
        if correctAnswer == sender.titleLabel?.text {
            displayImage(sysName: "checkmark", location: touchPosition!)
            changeButton(sender, bgColor: .green)
        } else {
            displayImage(sysName: "xmark", location: touchPosition!)
            changeButton(sender, bgColor: .red)
        }
        
        let seconds = 2.0
        
        self.options.forEach { $0.isEnabled = false }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.options.forEach { $0.isEnabled = true }
            self.questionLabel.slideInFromRight()
            self.questionLabel.text = "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?"
        }
        
    }
    
    
    @IBAction func exitButtonClicked(_ sender: UIBarButtonItem) {
        
        let refreshAlert = UIAlertController(title: "Exit Quiz?", message: "All of your progress will be lost.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          
            // Ensure that timer is still running, if needed
            
          }))
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
            self.navigationController?.pushViewController(vc, animated: true)
          }))

        present(refreshAlert, animated: true, completion: nil)
        
        // Reset quiz variables
        categoryName = nil
        categoryColor = nil
        
        numberOfQuestions = 10
        timeForQuestion = 15
        
        
        
        
    }
    
    func changeButton(_ button: UIButton, bgColor: UIColor) {
        
        let seconds = 2.0
        
        button.layer.borderWidth = 3.0
        button.layer.borderColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        button.backgroundColor = bgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            button.layer.borderWidth = 0.0
            button.backgroundColor = UIColor(red: 246/255, green: 223/255, blue: 235/255, alpha: 0.5)
            
        }
        
    }
    
    func displayImage(sysName: String, location: CGPoint) {
        
        let image = UIImage(systemName: sysName)
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(center: location, size: CGSize(width: 33, height: 33))
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
               imageView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2) // Scale your image
         }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                imageView.alpha = 0.0
          })
        }
        
        let seconds = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            imageView.removeFromSuperview()
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
