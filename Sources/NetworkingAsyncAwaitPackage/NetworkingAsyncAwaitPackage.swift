//
//  NetworkManager.swift
//  
//
//  Created by Julie Collazos on 23/03/2023.
//

import Foundation
import SwiftUI

class NetworkingAsyncAwaitPackage: ObservableObject {

    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    enum Method: String {
       case GET = "GET"
       case POST = "POST"
       case PUT = "PUT"
       case DELETE = "DELETE"
    }
    
    func getData<D: Decodable>(from endpoint: String) async throws -> D {
        guard let url = URL(string: endpoint)
        else {
            throw NetworkServiceError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Method.GET.rawValue
        
        let (data, response) = try await session.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            throw NetworkServiceError.invalidResponseCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(D.self, from: data)
    }
    
    func postData<D: Codable>(from endpoint: String, content: [String: String]) async throws -> D {
        guard let url = URL(string: endpoint)
        else {
            throw NetworkServiceError.invalidURL
        }
        
        let body: [String: String] = content
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Method.POST.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        urlRequest.httpBody = try? encoder.encode(body)
        
        let (data, _) = try await session.data(for: urlRequest)
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(D.self, from: data)
    }
    
}
