//
//  LoginServiceImpl.swift
//  OTPLogin
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate let baseUrl = "http://floral-cherry-7673.getsandbox.com/login"
fileprivate let validStatusCodes = 200..<300

fileprivate struct LoginSucessResponse: Decodable {
    var status: String
}

struct LoginServiceImpl: LoginService {
    
    init() {
        Logging.URLRequests = { _ in false }
    }
    
    func login(with otp: OneTimePassword)
        -> Single<String>
    {
        let request: URLRequest
        do {
            request = try makeRequest(httpMethod: "POST", urlStr: baseUrl, payload: otp)
        } catch {
            return Single.error(error)
        }
        
        return URLSession.shared.rx.response(request: request)
            .debug("POST /login")
            .flatMap{ response, data -> Observable<String> in
                if validStatusCodes ~= response.statusCode {
                    do {
                        let loginResponse = try JSONDecoder().decode(LoginSucessResponse.self, from: data)
                        return Observable.just(loginResponse.status)
                    } catch {
                        return Observable.error(WebServiceError.payloadDecodingError)
                    }
                } else {
                    let err = WebServiceError.unacceptableStatusCode(code: response.statusCode)
                    return Observable.error(err)
                }
            }
            .asSingle()
    }
    
}

extension LoginServiceImpl {
    
    private func makeRequest<T: Encodable>(httpMethod: String, urlStr: String, payload: T)
        throws
        -> URLRequest
    {
        guard let url = URL(string: urlStr) else {
            throw WebServiceError.invalidUrl(url: urlStr)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(payload)
        } catch {
            throw WebServiceError.payloadDecodingError
        }
        
        return request
    }
    
}
