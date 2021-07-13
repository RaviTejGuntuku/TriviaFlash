//
//  SlideAnimationExtension.swift
//  Trivler
//
//  Created by Tej Guntuku on 6/30/21.
//

import UIKit

extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func slideInFromRight(_ duration: TimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: CAAnimationDelegate = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = CATransitionType.push
        slideInFromRightTransition.subtype = CATransitionSubtype.fromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromRightTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
    
    func slideProgress(_ duration: TimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: CAAnimationDelegate = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = CATransitionType.moveIn
        slideInFromRightTransition.subtype = CATransitionSubtype.fromLeft
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideInFromRightTransition.fillMode = CAMediaTimingFillMode.forwards
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromRightTransition, forKey: "slideProgress")
    }
    
}
