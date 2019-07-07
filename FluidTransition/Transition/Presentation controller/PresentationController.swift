//
//  PresentationController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 29/06/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    var driver: TransitionDriver!
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        let halfHeight = screenBounds.height / 2
        return CGRect(x: 0, y: halfHeight, width: screenBounds.width, height: halfHeight)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.addSubview(presentedView!)
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        driver.direction = .dismiss
    }
}
