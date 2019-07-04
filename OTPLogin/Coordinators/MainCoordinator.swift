//
//  MainCoordinator.swift
//  OTPLogin
//
//  Created by Liyu Wang on 4/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
   
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController.instantiate()
        loginViewController.coordinator = self
        loginViewController.viewModel = LoginViewModel()
        self.navigationController.pushViewController(loginViewController, animated: false)
    }

}

extension MainCoordinator: ShowRewardCoordinator {
    
    func showRewardScreen() {
        let rewardViewController = RewardViewController.instantiate()
        self.navigationController.pushViewController(rewardViewController, animated: true)
    }
    
}
