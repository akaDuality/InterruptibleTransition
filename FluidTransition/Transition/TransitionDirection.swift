//
//  TransitionDirection.swift
//  FluidTransition
//
//  Created by Mikhail Rubanov on 14/07/2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import Foundation

enum TransitionDirection {
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
