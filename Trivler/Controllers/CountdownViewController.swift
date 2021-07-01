//
//  CountdownViewController.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/27/21.
//

import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet weak var countdownLabel: UILabel!
    
    var timeRemaining: Int = 3
    var timer: Timer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        zoomInText(text: "\(timeRemaining)")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        
    }
    
    func zoomInText(text: String) {
        
        countdownLabel.text = text
        
        countdownLabel.font = countdownLabel.font.withSize(150)
        
        countdownLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.0) {
            self.countdownLabel.transform = .identity
        }
        
    }
    
    @objc func step() {
        
        if timeRemaining > 1 {
            timeRemaining -= 1
            zoomInText(text: String(timeRemaining))
            
        } else {
            timer.invalidate()
            zoomInText(text: "Go!")
            
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.performSegue(withIdentifier: "CountdownToQuiz", sender: self)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

}
