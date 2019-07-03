//
//  LoginViewModel.swift
//  OTPLogin
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    // MARK: - incoming
    let password = BehaviorRelay<String>(value: "")
    
    // MARK: - outgoing
    var submitEnabledDriver: Driver<Bool> {
        return Observable.combineLatest(self.password, self.isLoading) {
            passwordText, isLoading in
            return passwordText.count > 0 && !isLoading
        }.asDriver(onErrorJustReturn: true)
    }
    
    var isLoadingDriver: Driver<Bool> {
        return self.isLoading.asDriver()
    }
    
    var errorObservable: Observable<Error> {
        return self.error.asObservable()
    }
    
    // MARK: - private
    
    private let bag = DisposeBag()
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let error = PublishRelay<Error>()
    
    private let webService: LoginService
    
    // MARK: - initializers
    
    init(webService: LoginService = LoginServiceImpl()) {
        self.webService = webService
    }
    
}

extension LoginViewModel {
    
    func login() -> Single<Void> {
        self.isLoading.accept(true)
        
        return self.webService
            .login(with: OneTimePassword(code: self.password.value))
            .map { _ in return () }
            .do(
                onError: { error in
                    self.error.accept(error)
                },
                onDispose: {
                    self.isLoading.accept(false)
                }
            )
    }
    
}
