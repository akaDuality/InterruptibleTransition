//
//  ViewController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 28/06/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    @IBAction func openDidPress(_ sender: Any) {
        let child = ChildViewController()
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        
        present(child, animated: true)
    }
    
    private let transition = PanelTransition()
}
