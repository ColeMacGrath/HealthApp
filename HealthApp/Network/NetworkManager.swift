//
//  RequestManager.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-11-30.
//

import Foundation

fileprivate enum EndPoint: String {
    case login
    case doctors
}

@globalActor
actor NetworkActor {
    static let shared = NetworkActor()
}

@NetworkActor
final class NetworkManager {
    static let shared = NetworkManager(isLoggedIn: true)
    private let baseURL: URL
    private(set) var isLoggedIn: Bool
    
    private init(isLoggedIn: Bool) {
        guard let baseURL = URL(string: "https://api.healthapp.local") else { fatalError("Invalid base URL") }
        self.baseURL = baseURL
        self.isLoggedIn = isLoggedIn
    }
    
    private func checkForAuthorization(statusCode: HTTPStatusCode) async {
        guard statusCode == .unauthorized else { return }
        await MainActor.run {
            SessionManager.shared.loginData = nil
        }
    }
    
    private func perform<T: Decodable>(request: URLRequest, responseType: T.Type) async -> (statusCode: HTTPStatusCode, data: T?) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return (.unknown, nil)
            }
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode)
            let doctors = try JSONDecoder().decode(T.self, from: data)
            await checkForAuthorization(statusCode: statusCode)
            return (statusCode, try? JSONDecoder().decode(T.self, from: data))
        } catch {
            print(error.localizedDescription)
            return (.unknown, nil)
        }
    }
    
    private func perform(request: URLRequest) async -> HTTPStatusCode {
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return .unknown }
            let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode)
            await checkForAuthorization(statusCode: statusCode)
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
        let (statusCode, data) = await perform(request: request, responseType: LoginResponse.self)
        await KeychainManager.shared.save(data, forKey: "loginResponse")
        await MainActor.run {
            SessionManager.shared.loginData = data
        }
        return statusCode
    }
    
    func doctorList() async -> (statusCode: HTTPStatusCode, doctors: [Doctor]?) {
        guard let userId = await SessionManager.shared.getUserId() else { return (.unauthorized, nil) }
        let url = baseURL
            .appendingPathComponent("\(userId)")
            .appendingPathComponent(EndPoint.doctors.rawValue)
        guard let request = URLRequest.createRequest(method: .GET, url: url) else { return (.unknown, nil) }
        let response = await perform(request: request, responseType: DoctorResponse.self)
        print(response.data?.doctors.count)
        return (response.statusCode, response.data?.doctors)
    }
    
}
