//
//  OTPLoginTests.swift
//  OTPLoginTests
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import XCTest
@testable import OTPLogin
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

class OTPLoginTests: XCTestCase {

    private var bag: DisposeBag!
    private var scheduler: TestScheduler!
    
    private var loginViewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        self.bag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        self.loginViewModel = nil
        super.tearDown()
    }
    
    func testSubmitEnabledByPasswordInput() {
        self.loginViewModel = LoginViewModel()
        
        let submitEnabled = self.scheduler.createObserver(Bool.self)
        
        self.loginViewModel.submitEnabledDriver
            .drive(submitEnabled)
            .disposed(by: bag)
        
        self.scheduler.createColdObservable([.next(10, "a"),
                                             .next(11, "ab"),
                                             .next(12, "a"),
                                             .next(13, "")])
            .bind(to: self.loginViewModel.password)
            .disposed(by: bag)
        
        self.scheduler.start()
        
        XCTAssertRecordedElements(submitEnabled.events, [false, true, true, true, false])
    }
    
    func testSubmitDisabledByLogin() {
        self.loginViewModel = LoginViewModel()
        
        let submitEnabled = self.scheduler.createObserver(Bool.self)
        
        self.loginViewModel.submitEnabledDriver
            .drive(submitEnabled)
            .disposed(by: bag)
        
        self.loginViewModel.password.accept("1234")
        
        _ = self.loginViewModel.login()
            .toBlocking()
            .materialize()
        
        XCTAssertRecordedElements(submitEnabled.events, [false, true, false, true])
    }
    
    func testIsLoading() {
        self.loginViewModel = LoginViewModel(webService: MockLoginSuccessWebService())

        let isLoading = self.scheduler.createObserver(Bool.self)
        
        self.loginViewModel.isLoadingDriver
            .drive(isLoading)
            .disposed(by: bag)
        
        _ = self.loginViewModel.login()
            .toBlocking()
            .materialize()
        
        XCTAssertRecordedElements(isLoading.events, [false, true, false])
    }

    func testUnauthorizedLoginError() {
        self.loginViewModel = LoginViewModel(webService: MockLoginFailureWebService())
        
        let error = self.scheduler.createObserver(Error.self)
        
        self.loginViewModel.errorObservable
            .bind(to: error)
            .disposed(by: bag)
        
        _ = self.loginViewModel.login()
            .toBlocking()
            .materialize()
        
        XCTAssertEqual(error.events.count, 1)
        
        if let err = error.events.first?.value.element as? WebServiceError,
            case .unacceptableStatusCode(let code) = err {
            XCTAssertEqual(code, 401, "Expected status code 401, but received \(code)")
        } else {
            XCTFail("Expected status code 401")
        }
    }

}

private struct MockLoginSuccessWebService: LoginService {
    
    func login(with otp: OneTimePassword) -> Single<String> {
        return Single.just("ok")
    }
    
}

private struct MockLoginFailureWebService: LoginService {
   
    func login(with otp: OneTimePassword) -> Single<String> {
        return Single.error(WebServiceError.unacceptableStatusCode(code: 401))
    }
    
}
