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
            return false
        }
        
        set { }
    }
    
    
    func link(to controller: UIViewController) {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        controller.view.addGestureRecognizer(panRecognizer)
        
        self.presentedController = controller
    }
    
    @objc private func handle(recognizer r: UIPanGestureRecognizer) {
        let view = r.view!
        let maxValue = r.view!.bounds.height
        let location = r.location(in: view)
        
        switch r.state {
        case .began:
            self.pause()
            
//            if direction == .dismiss {
//                presentedController?.dismiss(animated: true)
//            }
            
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
            
            if endLocation.y < maxValue / 2 && direction == .present {
                let estimatedTranslation = -endLocation.y
                let completionSpeed = maxValue / estimatedTranslation
                self.completionSpeed = 1 + completionSpeed
                finish()
            } else {
                let estimatedTranslation = maxValue - endLocation.y
                let completionSpeed = maxValue / estimatedTranslation
                self.completionSpeed = 1 + completionSpeed
                cancel()
            }
            
            self.direction.toggle()
            
        default:
            break
        }
    }
}
