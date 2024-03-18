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
    case bookApointment = "bookAppointment"
    case appointments = "appointments"
    case patients = "patients"
}

enum User: String {
    case patient
    case doctor
    case none
}

enum HTTPStatusCode: Int {
    case success = 200
    case created = 201
    case empty = 204
    case unauthorized = 401
    case conflict = 409
    case localError = 900
}

class RequestManager {
    static let shared = RequestManager()
    let baseURL: String
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private init() {
        self.baseURL = "https://api.healthApp.local/"
    }
    
    func request(url: URL? = nil, endPoint: EndPoint? = nil, method: HTTPMethod, body: [String: Any]? = nil, headers: [String: String]? = nil) async -> (httpStatusCode: HTTPStatusCode, body: Dictionary<String, Any>?, rawData: Data?) {
        
        guard let url = url ?? URL(string: self.baseURL + (endPoint?.rawValue ?? .empty)) else { return (.localError, nil, nil) }
        var request = URLRequest(url: url)
        var headers = headers
        
        request.httpMethod = method.rawValue
        headers = headers == nil ? [:] : headers
        
        if SessionManager.shared.isLoggedIn {
            guard let sessionToken = SessionManager.shared.getSessionToken() else {
                SessionManager.shared.logOut()
                return (.localError, nil, nil)
            }
            headers?["sessionToken"] = sessionToken
            headers?["userType"] = SessionManager.shared.getPatientId() != nil ? "patient" : "doctor"
        }
        
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
            guard self.getHTTPStatusCodeFrom(statusCode: statusCode) != .unauthorized else {
                SessionManager.shared.logOut()
                return (.unauthorized, nil, nil)
            }
            
            let responseBody = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any>
            
            return (self.getHTTPStatusCodeFrom(statusCode: statusCode), responseBody, data)
        } catch {
            return (.localError, nil, nil)
        }
    }
    
    func getURLWithPatientFor(endpoint: EndPoint) -> URL? {
        self.getURLWithIdFor(user: .patient, endpoint: endpoint)
    }
    
    func getURLWithDoctorFor(endpoint: EndPoint) -> URL? {
        self.getURLWithIdFor(user: .doctor, endpoint: endpoint)
    }
    
    private func getURLWithIdFor(user: User, endpoint: EndPoint) -> URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        let userId = user == .patient ? self.getPatientId() : self.getDoctorId()
        let endpointPath = endpoint.rawValue
        let fullPath = "\(userId)/\(endpointPath)"
        components.path = (components.path) + fullPath
        return components.url
    }
    
    private func getPatientId() -> String {
        return "\(0)"
    }
    
    private func getDoctorId() -> String {
        return "\(0)"
    }
    
    private func getHTTPStatusCodeFrom(statusCode: Int) -> HTTPStatusCode {
        guard let responseCode = HTTPStatusCode(rawValue: statusCode) else { return .localError }
        return responseCode
    }
}
