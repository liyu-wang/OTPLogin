//
//  Storyboarded.swift
//  OTPLogin
//
//  Created by Liyu Wang on 4/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import UIKit

protocol Storyboarded {
    
    static func instantiate(storyboardName: String) -> Self
    
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(storyboardName: String = "Main") -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
    
}
