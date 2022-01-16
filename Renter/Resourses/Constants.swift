//
//  Constants.swift
//  Renter
//
//  Created by Oleg Efimov on 15.01.2022.
//

import UIKit

struct Constants {
    
    static let primaryColor = UIColor(
        red: 47 / 255,
        green: 128 / 255,
        blue: 237 / 255,
        alpha: 1)
    
    static var fadeTransition: CATransition {
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        transition.type = .fade
        transition.subtype = .none
        return transition
    }
    
    private init(){}
}
