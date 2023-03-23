//
//  NetworkManager.swift
//  
//
//  Created by Julie Collazos on 23/03/2023.
//

import Foundation
import SwiftUI

public final class NetworkManager: ObservableObject {

   public let session = URLSession.shared
    public let encoder = JSONEncoder()
    public let decoder = JSONDecoder()
    
    public enum Method: String {
       case GET = "GET"
       case POST = "POST"
       case PUT = "PUT"
       case DELETE = "DELETE"
    }
    
    public func getData<D: Decodable>(from endpoint: String) async throws -> D {
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
    
    public func postData<D: Codable>(from endpoint: String, content: [String: String]) async throws -> D {
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
