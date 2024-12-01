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
    case patients = "patients"
    case appointment = "appointment"
    case appointments = "appointments"
    case bookApointment = "bookAppointment"
}

enum User: String {
    case none
    case doctor
    case patient
}

enum HTTPStatusCode: Int {
    case success = 200
    case created = 201
    case empty = 204
    case unauthorized = 401
    case conflict = 409
    case localError = 900
}

fileprivate struct RequestManagerIdentifier {
    let baseURL = "https://api.healthApp.local/"
    let sessionToken = "sessionToken"
    let patient = "patient"
    let userTyoe = "userType"
    let doctor = "doctor"
}

class RequestManager {
    static let shared = RequestManager()
    private let identifiers = RequestManagerIdentifier()
    let baseURL: String
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private init() {
        self.baseURL = self.identifiers.baseURL
    }
    
    private func getURLWithIdFor(user: User, endpoint: EndPoint) -> URL? {
        guard var components = URLComponents(string: baseURL),
              let userId = user == .patient ? SessionManager.shared.getPatientId() : SessionManager.shared.getDoctorId() else { return nil }
        let endpointPath = endpoint.rawValue
        let fullPath = "\(userId)/\(endpointPath)"
        components.path = (components.path) + fullPath
        return components.url
    }
    
    private func getHTTPStatusCodeFrom(statusCode: Int) -> HTTPStatusCode {
        guard let responseCode = HTTPStatusCode(rawValue: statusCode) else { return .localError }
        return responseCode
    }
    
    private func makeRequest(url: URL? = nil, endPoint: EndPoint? = nil, method: HTTPMethod, body: [String: Any]? = nil, headers: [String: String]? = nil) async -> (httpStatusCode: HTTPStatusCode, body: Dictionary<String, Any>?, rawData: Data?) {
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
            headers?[self.identifiers.sessionToken] = sessionToken
            headers?[self.identifiers.userTyoe] = SessionManager.shared.getPatientId() != nil ? self.identifiers.patient : self.identifiers.doctor
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
    
    func request(url: URL, method: HTTPMethod, body: [String: Any]? = nil, headers: [String: String]? = nil) async -> (httpStatusCode: HTTPStatusCode, body: Dictionary<String, Any>?, rawData: Data?) {
        return await makeRequest(url: url, method: method, body: body, headers: headers)
    }
    
    func request(endPoint: EndPoint, method: HTTPMethod, body: [String: Any]? = nil, headers: [String: String]? = nil) async -> (httpStatusCode: HTTPStatusCode, body: Dictionary<String, Any>?, rawData: Data?) {
        return await makeRequest(endPoint: endPoint, method: method, body: body, headers: headers)
    }
    
    func getURLWithPatientFor(endpoint: EndPoint) -> URL? {
        self.getURLWithIdFor(user: .patient, endpoint: endpoint)
    }
    
    func getURLWithDoctorFor(endpoint: EndPoint) -> URL? {
        self.getURLWithIdFor(user: .doctor, endpoint: endpoint)
    }
}
