//
//  PresentAnimation.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 07/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.3
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
    
    var animator: UIViewPropertyAnimator?
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let to = transitionContext.view(forKey: .to)!
        
        to.transform = CGAffineTransform(translationX: 0, y: to.bounds.height)
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            to.transform = .identity
        }
        
        animator!.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator!
    }
}
