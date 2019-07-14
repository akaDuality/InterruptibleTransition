//
//  DismissAnimation.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 07/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.3
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
    
    var animator: UIViewPropertyAnimator?
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let from = transitionContext.view(forKey: .from)!
        
        let initialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: .from)!)
        
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            from.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        }
        
        animator!.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator!
    }
}
