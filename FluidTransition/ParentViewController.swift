//
//  ViewController.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 28/06/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openDidPress(_ sender: Any) {
        self.present(ChildViewController(), animated: true)
    }
}

class ChildViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
}

