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
        
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            to.frame = finalFrame
        }
        
        animator!.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator!
    }
}
