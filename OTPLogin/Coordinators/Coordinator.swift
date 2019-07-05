//
//  Coordinator.swift
//  OTPLogin
//
//  Created by Liyu Wang on 4/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { set get }
    
    func start()
    
}
