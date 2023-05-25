//
//  ViewController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 28/06/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    private let transition = PanelTransition()
    
    @IBAction func openDidPress(_ sender: Any) {
        let child = ChildViewController()
        child.modalPresentationStyle = .custom
        child.transitioningDelegate = transition
        
        present(child, animated: true)
    }
}
