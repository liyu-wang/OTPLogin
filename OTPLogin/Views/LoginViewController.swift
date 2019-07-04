//
//  LoginViewController.swift
//  OTPLogin
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ShowRewardCoordinator: AnyObject {
    
    func showRewardScreen()

}

class LoginViewController: BaseViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    weak var coordinator: ShowRewardCoordinator?
    
    var viewModel: LoginViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupReactive()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

// MARK: - Rx

extension LoginViewController {
    
    func setupReactive() {
        self.passwordField.rx.text.orEmpty
            .bind(to: self.viewModel.password)
            .disposed(by: bag)
        
        self.viewModel.submitEnabledDriver
            .drive(self.submitButton.rx.isEnabled)
            .disposed(by: bag)
        
        self.viewModel.isLoadingDriver
            .map { !$0 }
            .drive(self.loadingSpinner.rx.isHidden)
            .disposed(by: bag)
        
        self.viewModel.errorObservable
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] error in
                    self?.showAlert(for: error)
                }
            )
            .disposed(by: bag)
        
        self.submitButton.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.login()
                }
            )
            .disposed(by: bag)
    }
    
}

// MARK: - actions

extension LoginViewController {
    
    func login() {
        self.viewModel.login()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] in
                    self?.coordinator?.showRewardScreen()
                }
            )
            .disposed(by: bag)
    }
    
}
