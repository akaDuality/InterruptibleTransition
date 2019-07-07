//
//  TransitionDriver.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 07/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class TransitionDriver: UIPercentDrivenInteractiveTransition {
    private var presentedController: UIViewController?
    
    enum Direction {
        case present, dismiss
        
        mutating func toggle() {
            switch self {
            case .present:
                self = .dismiss
            case .dismiss:
                self = .present
            }
        }
    }
    
    var direction: Direction = .present
    
    override var wantsInteractiveStart: Bool {
        get {
            switch direction {
            case .present:
                return false
            case .dismiss:
                return isInteractiveDismiss
            }
        }
        
        set { }
    }
    
    
    func link(to controller: UIViewController) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        controller.view.addGestureRecognizer(panRecognizer)
        
        self.presentedController = controller
    }
    
    var isInteractiveDismiss: Bool = false
    
    @objc private func handle(recognizer r: UIPanGestureRecognizer) {
        let view = r.view!
        let maxValue = r.view!.bounds.height
        let location = r.location(in: view)
        
        switch r.state {
        case .began:
            self.pause()
            
            if direction == .dismiss {
                isInteractiveDismiss = true
                presentedController?.dismiss(animated: true)
                self.update(0)
            }
            
        case .changed:
            let translation = r.translation(in: view).y
            r.setTranslation(.zero, in: nil)
            
            switch direction {
            case .present:
                let percentIncrement = -translation / maxValue
                self.update(self.percentComplete + percentIncrement)
            case .dismiss:
                let percentIncrement = translation / maxValue
                self.update(self.percentComplete + percentIncrement)
            }
            
        case .ended, .cancelled:
            let velocityOffset = r.velocity(in: view).projectedOffset(decelerationRate: .normal)
            let endLocation = location + velocityOffset
            
            let isPresentationCompleted = endLocation.y < maxValue / 2
            let presentationCompetion = self.presentationCompetion(endLocation: endLocation, maxValue: maxValue)
            let dismissCompetion      = self.dismissCompetion(endLocation: endLocation, maxValue: maxValue)
            
            switch direction {
            case .present:
                if isPresentationCompleted{
                    self.completionSpeed = 1 + presentationCompetion
                    finish()
                } else {
                    self.completionSpeed = 1 + dismissCompetion
                    cancel()
                }
            case .dismiss:
                if isPresentationCompleted{
                    self.completionSpeed = 1 + presentationCompetion
                    cancel()
                } else {
                    self.completionSpeed = 1 + dismissCompetion
                    finish()
                }
            }
            
        default:
            break
        }
    }
    
    private func presentationCompetion(endLocation: CGPoint, maxValue: CGFloat) -> CGFloat {
        let estimatedTranslation = -endLocation.y
        let completionSpeed = maxValue / estimatedTranslation
        return completionSpeed
    }
    
    private func dismissCompetion(endLocation: CGPoint, maxValue: CGFloat) -> CGFloat {
        let estimatedTranslation = maxValue - endLocation.y
        let completionSpeed = maxValue / estimatedTranslation
        return completionSpeed
    }
}
