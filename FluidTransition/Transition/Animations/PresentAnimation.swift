//
//  PresentAnimation.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 07/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

protocol FloatingViewSourceTransition {
    func floatingView() -> UIView
}

struct Destination {
    let parentView: UIView
    let frameInParentCoordinates: CGRect
}

protocol FloatingViewDestinationTransition {
    func destination() -> Destination
}

class PresentAnimation: NSObject {
    let duration: TimeInterval = 0.3

    private func animator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        animateCard(using: transitionContext, on: animator)
        animateFloatingView(using: transitionContext, on: animator)
        
        return animator
    }
    
    private func animateCard(
        using transitionContext: UIViewControllerContextTransitioning,
        on animator: UIViewPropertyAnimator
    ) {
        let to = transitionContext.view(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)

        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        animator.addAnimations {
            to.frame = finalFrame
        }
    }
    
    private func animateFloatingView(
        using transitionContext: UIViewControllerContextTransitioning,
        on animator: UIViewPropertyAnimator
    ) {
        let to = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        
        let fromController = transitionContext.viewController(forKey: .from)
        let floatingView = (fromController as! FloatingViewSourceTransition).floatingView()
        
        let toController = transitionContext.viewController(forKey: .to)
        let destination = (toController as! FloatingViewDestinationTransition).destination()
        
        let screenFrame = floatingView.convert(floatingView.bounds, to: containerView)
        containerView.addSubview(floatingView)
        floatingView.frame = screenFrame
        
        animator.addAnimations {
            floatingView.frame = destination.frameInParentCoordinates
        }
        
        animator.addCompletion { (position) in
            let toFrame = floatingView.convert(floatingView.bounds, to: to)
            destination.parentView.addSubview(floatingView)
            floatingView.frame = toFrame
        }
    }
}

extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}

// MARK: - iOS 9
//extension PresentAnimation {
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let to = transitionContext.view(forKey: .to)!
//        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
//
//        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
//
//        UIView.animate(withDuration: duration, delay: 0,
//                       usingSpringWithDamping: 1, initialSpringVelocity: 0,
//                       options: [.curveEaseOut], animations: {
//                        to.frame = finalFrame
//        }) { (_) in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//}
