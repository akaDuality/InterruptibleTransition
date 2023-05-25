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
    
    let square: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        square.backgroundColor = .blue
        view.addSubview(square)
        square.frame = CGRect(x: 147, y: 100, width: 100, height: 100)
    }
    
    @IBAction func openDidPress(_ sender: Any) {
        let child = ChildViewController()
        child.modalPresentationStyle = .custom
        child.transitioningDelegate = transition
        
        present(child, animated: true)
    }
}

extension ParentViewController: FloatingViewSourceTransition {
    func floatingView() -> UIView {
        square
    }
}
