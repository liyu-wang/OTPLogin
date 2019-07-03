//
//  LoginServiceTests.swift
//  OTPLoginTests
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
@testable import OTPLogin

class LoginServiceTests: XCTestCase {

    var loginService: LoginService!
    
    override func setUp() {
        super.setUp()
        self.loginService = LoginServiceImpl()
    }

    override func tearDown() {
        self.loginService = nil
        super.tearDown()
    }

    func testLoginSuccess() {
        let result = self.loginService.login(with: OneTimePassword(code: "1234"))
            .toBlocking()
            .materialize()
        
        switch result {
        case .completed(let elements):
            XCTAssertEqual(elements.first, "ok", "Expected status to be ok, but received \(elements.first ?? "nil").")
        case .failed(_, let error):
            XCTFail("Expected result to complete without error, but received \(error).")
        }
    }
    
    func testLoginFailure() {
        let result = self.loginService.login(with: OneTimePassword(code: "5678"))
            .toBlocking()
            .materialize()
        
        switch result {
        case .completed(_):
            XCTFail("Expected result to be an error.")
        case .failed(_, let error):
            if let err = error as? WebServiceError,
                case .unacceptableStatusCode(let code) = err {
                XCTAssertEqual(code, 401, "Expected status code 401, but received \(code)")
            } else {
                XCTFail("Expected status code 401")
            }
        }
    }

}
