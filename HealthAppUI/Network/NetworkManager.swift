//
//  RequestManager.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-30.
//

import Foundation

fileprivate enum EndPoint: String {
    case login
}

@globalActor
actor NetworkActor {
    static let shared = NetworkActor()
}

@NetworkActor
final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL: URL
    
    private init() {
        guard let baseURL = URL(string: "https://api.healthapp.local") else { fatalError("Invalid base URL") }
        self.baseURL = baseURL
    }
    
    private func perform<T: Decodable>(request: URLRequest, responseType: T.Type) async -> (data: T?, statusCode: HTTPStatusCode) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return (nil, .unknown)
            }
            
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode)
            
            if !data.isEmpty {
                let decodedData = try? JSONDecoder().decode(T.self, from: data)
                return (decodedData, statusCode)
            } else {
                return (nil, statusCode)
            }
        } catch {
            return (nil, .unknown)
        }
    }
    
    private func perform(request: URLRequest) async -> HTTPStatusCode {
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { return .unknown }
            
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode)
            return statusCode
        } catch {
            return .unknown
        }
    }
    
}

extension NetworkManager {
    func login(username: String, password: String) async -> HTTPStatusCode {
        let loginRequest = LoginRequest(username: username, password: password)
        let url = baseURL.appendingPathComponent(EndPoint.login.rawValue)
        guard let request = URLRequest.createRequest(method: .POST, url: url, body: loginRequest) else { return .unknown }
        let (data, statusCode) = await perform(request: request, responseType: LoginResponse.self)
        await KeychainManager.shared.save(data, forKey: "loginResponse")
        return statusCode
    }
}
