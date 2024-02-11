//
//  RequestManager.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 03/01/24.
//

import Foundation

enum EndPoint: String {
    case login = "login"
    case doctors = "doctors"
}

enum HTTPStatusCode: Int {
    case success = 200
    case unauthorized = 401
    case localError = 900
}

class RequestManager {
    static let shared = RequestManager()
    let baseURL: String
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        // Add other methods as needed
    }
    
    private init() {
        self.baseURL = "https://api.healthApp.local/"
    }
    
    
    func request(url: URL? = nil, endPoint: EndPoint? = nil, method: HTTPMethod, body: [String: Any]? = nil, headers: [String: String]? = nil) async -> (httpStatusCode: HTTPStatusCode, body: Dictionary<String, Any>?, rawData: Data?) {
        
        guard let url = url ?? URL(string: self.baseURL + (endPoint?.rawValue ?? .empty)) else { return (.localError, nil, nil) }
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        if let body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return (.localError, nil, nil)
            }
            
            let statusCode = httpResponse.statusCode
            let responseBody = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any>
            
            return (self.getHTTPStatusCodeFrom(statusCode: statusCode), responseBody, data)
        } catch {
            return (.localError, nil, nil)
        }
    }
    
    private func getHTTPStatusCodeFrom(statusCode: Int) -> HTTPStatusCode {
        guard let responseCode = HTTPStatusCode(rawValue: statusCode) else { return .localError }
        return responseCode
    }
}
