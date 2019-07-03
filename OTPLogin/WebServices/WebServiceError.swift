//
//  WebServiceError.swift
//  OTPLogin
//
//  Created by Liyu Wang on 3/7/19.
//  Copyright © 2019 Liyu Wang. All rights reserved.
//

import Foundation

enum WebServiceError: Error {
    
    case invalidUrl(url: String)
    case payloadEncodingError
    case payloadDecodingError
    case unacceptableStatusCode(code: Int)
    
}

extension WebServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl(let url):
            return "Invalid url \(url)."
        case .payloadEncodingError:
            return "Failed to encode object."
        case .payloadDecodingError:
            return "Failed to decode JSON."
        case .unacceptableStatusCode(let code):
            return "unacceptable status code: \(code)."
        }
    }
    
}
