//
//  ViewController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 28/06/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    private var child: ChildViewController!
    private var transition: PanelTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        child = ChildViewController()
        transition = PanelTransition(presented: child, presenting: self)
        
        // Setup the child
        child.modalPresentationStyle = .custom
        child.transitioningDelegate = transition
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    
    @IBAction func openDidPress(_ sender: Any) {
        self.present(child, animated: true)
    }
}
