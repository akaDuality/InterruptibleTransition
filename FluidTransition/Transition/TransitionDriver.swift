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
                let gestureIsActive = panRecognizer?.state == .began
                return gestureIsActive
            }
        }
        
        set { }
    }
    
    private var panRecognizer: UIPanGestureRecognizer?
    
    func link(to controller: UIViewController) {
        presentedController = controller
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }
    
    @objc private func handle(recognizer r: UIPanGestureRecognizer) {
        switch direction {
        case .present:
            handlePresentation(recognizer: r)
        case .dismiss:
            handleDismiss(recognizer: r)
        }
    }
    
    private func handlePresentation(recognizer r: UIPanGestureRecognizer) {
        switch r.state {
        case .began:
            pause()
        case .changed:
            let increment = -r.incrementToBottom()
            update(percentComplete + increment)
            
        case .ended, .cancelled:
            if r.isProjectedToDownHalf{
                cancel()
            } else {
                finish()
            }
            
        case .failed:
            cancel()
            
        default:
            break
        }
    }
    
    private func handleDismiss(recognizer r: UIPanGestureRecognizer) {
        switch r.state {
        case .began:
            pause()
            
            let isNotDismissing = presentedController!.view.transform == .identity
            if isNotDismissing {
                presentedController?.dismiss(animated: true)
            } else {
                pause() // Pause already dismissing transition
            }
            
        case .changed:
            update(percentComplete + r.incrementToBottom())
            
        case .ended, .cancelled:
            if r.isProjectedToDownHalf {
                finish()
            } else {
                cancel()
            }

        case .failed:
            cancel()
            
        default:
            break
        }
    }
}

private extension UIPanGestureRecognizer {
    
    var maxValue: CGFloat {
        return view!.bounds.height
    }
    
    var isProjectedToDownHalf: Bool {
        let endLocation = projectedOffset(decelerationRate: .fast)
        let isPresentationCompleted = endLocation.y > maxValue / 2
        
        return isPresentationCompleted
    }
    
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        let velocityOffset = velocity(in: view).projectedOffset(decelerationRate: .normal)
        let result = location(in: view!) + velocityOffset
        return result
    }
    
    func incrementToBottom() -> CGFloat {
        let translation = self.translation(in: view).y
        setTranslation(.zero, in: nil)
        
        let percentIncrement = translation / maxValue
        return percentIncrement
    }
}
