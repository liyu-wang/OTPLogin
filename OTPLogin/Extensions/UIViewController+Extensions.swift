//
//  UIViewController+Extensions.swift
//  OTPLogin
//
//  Created by Liyu Wang on 4/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(for error: Error, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            completion?()
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
