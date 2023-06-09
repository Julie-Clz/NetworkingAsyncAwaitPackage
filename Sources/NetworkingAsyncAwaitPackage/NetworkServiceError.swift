//
//  NetworkServiceError.swift
//  
//
//  Created by Julie Collazos on 23/03/2023.
//

import Foundation

public enum NetworkServiceError: Error {
    case invalidURL
//    case decodingError(String)
//    case genericError(String)
    case invalidResponseCode(Int)
    
    public var errorMessageString: String {
        switch self {
        case .invalidURL:
            return "Invalid URL encountered. Can't proceed with the request"
//        case .decodingError:
//            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
//        case .genericError(let message):
//            return message
        case .invalidResponseCode(let responseCode):
            return "Invalid response code encountered from the server. Expected 200, received \(responseCode)"
        }
    }
}

