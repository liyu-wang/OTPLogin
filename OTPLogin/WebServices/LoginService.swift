//
//  LoginService.swift
//  OTPLogin
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginService {
    
    func login(with otp: OneTimePassword) -> Single<String>
    
}
