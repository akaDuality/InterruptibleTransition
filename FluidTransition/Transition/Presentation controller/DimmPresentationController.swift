//
//  DimmPresentationController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 07/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class DimmPresentationController: PresentationController {
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.insertSubview(dimmView, at: 0)
        dimmView.frame = containerView!.frame
        
        performAlongsidetranstionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        performAlongsidetranstionIfPossible { [unowned self] in
            self.dimmView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    private func performAlongsidetranstionIfPossible(_ block: @escaping () -> Void) {
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                block()
            }, completion: nil)
        } else {
            block()
        }
    }
    
    private var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.alpha = 0
        return view
    }()
}
