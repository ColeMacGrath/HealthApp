//
//  Extensions.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-31.
//

import Foundation
import SwiftUI

extension Date {
    func differenceBetween(date: Date) -> (hours: Int, minutes: Int)? {
        let firstDate = self
        let seconDate = date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: firstDate, to: seconDate)
        guard let hours = components.hour,
              let minutes = components.minute else { return nil }
        
        return (hours, minutes)
    }
    
    var monthDayYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: self)
    }
    
    static var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    static var weekAgo: Date {
        Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
    }
    
    static var monthAgo: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    }
    
    static var yearAgo: Date {
        Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    }
    
    static func date(groupedBy: GroupedBy) -> Date {
        switch groupedBy {
        case .day:
            return .today
        case .week:
            return .weekAgo
        case .month:
            return .monthAgo
        case .year:
            return .yearAgo
        default:
            return .distantPast
        }
    }
    
    func dayMonthYearAndHourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd, MMMM yyyy: hh:mm a"
        return formatter.string(from: self)
    }
}

extension String {
    static var empty: String {
        return ""
    }
}
extension View {
    func CapsuleButtonStyle(backgroundColor: Color = .accent, fontColor: Color = .white, cornerRadius: CGFloat = 18.0, image: Image? = nil, imageForegroundColor: Color = .white) -> some View {
        self.modifier(CapsuleButtonModifier(backgroundColor: backgroundColor, fontColor: fontColor, cornerRadius: cornerRadius, image: image, imageForegroundColor: imageForegroundColor))
    }
    
    func loadingView(isPresented: Binding<Bool>, message: String? = nil, color: Color = .accentColor, fullScreen: Bool = false) -> some View {
        self.modifier(LoadingAlertModifier(isPresented: isPresented, message: message, color: color, fullscreen: fullScreen))
    }
    
    func withDisclosureIndicator() -> some View {
        self.modifier(DisclosureIndicatorModifier())
    }
}

extension Image {
    func circularImageStyle(color: Color) -> some View {
        self
            .resizable()
            .modifier(CircularImageModifier(color: color))
    }
}

extension Font {
    static var defaultFont: Font {
        Font.custom("Helvetica-Neue", size: 16.0)
    }
}

extension Array where Element == Doctor {
    static var doctorsSample: [Doctor] {
        [
            /*Doctor(
                firstName: "Maria",
                lastName: "Lopez",
                description: "Dr. Maria Lopez is an empathetic Neurology Specialist, guiding patients through complex neurological disorders with care and the latest treatment advancements.",
                specialization: "Neurology Specialist",
                profilePicture: Image("doctor0"),
                lightBackgroundColor: Color(red: 0.929, green: 0.808, blue: 0.855),
                darkBackgroundColor: Color(red: 0.353, green: 0.106, blue: 0.196) // Deep wine red
            ),
            Doctor(
                firstName: "Elena",
                lastName: "Wu",
                description: "Dr. Elena Wu is passionate about Immunology, working with patients to manage allergies and immune-related disorders through science-driven solutions and patient education.",
                specialization: "Immunology Specialist",
                profilePicture: Image("doctor1"),
                lightBackgroundColor: Color(red: 0.839, green: 0.898, blue: 0.886), // Gentle mint green
                darkBackgroundColor: Color(red: 0.086, green: 0.271, blue: 0.251) // Dark pine green
            ),
            Doctor(
                firstName: "Priya",
                lastName: "Nair",
                description: "Dr. Priya Nair is a caring OB/GYN, dedicated to supporting women's health at every life stage with expertise in reproductive and prenatal care.",
                specialization: "Obstetrics and Gynecology Specialist",
                profilePicture: Image("doctor2"),
                lightBackgroundColor: Color(red: 0.929, green: 0.902, blue: 0.804), // Warm beige
                darkBackgroundColor: Color(red: 0.271, green: 0.196, blue: 0.098) // Dark earthy brown
            ),
            Doctor(
                firstName: "Rafael",
                lastName: "Martinez",
                description: "Dr. Rafael Martinez is a dedicated Rheumatology Specialist, helping patients manage autoimmune and joint disorders with comprehensive, personalized care.",
                specialization: "Rheumatology Specialist",
                profilePicture: Image("doctor3"),
                lightBackgroundColor: Color(red: 0.859, green: 0.839, blue: 0.929), // Light lavender
                darkBackgroundColor: Color(red: 0.149, green: 0.106, blue: 0.353) // Deep royal purple
            ),
            Doctor(
                firstName: "Henry",
                lastName: "Foster",
                description: "Dr. Henry Foster is a compassionate Oncology Specialist committed to supporting patients through their cancer journey with innovative treatments and a patient-centered approach.",
                specialization: "Oncology Specialist",
                profilePicture: Image("doctor4"),
                lightBackgroundColor: Color(red: 0.804, green: 0.929, blue: 0.859), // Soft pastel green
                darkBackgroundColor: Color(red: 0.086, green: 0.271, blue: 0.196) // Forest green
            ),
            Doctor(
                firstName: "Samuel",
                lastName: "Hayes",
                description: "Dr. Samuel Hayes focuses on respiratory health, providing thorough care for conditions such as asthma and COPD, ensuring patients breathe easier and live better.",
                specialization: "Pulmonology Specialist",
                profilePicture: Image("doctor5"),
                lightBackgroundColor: Color(red: 0.929, green: 0.851, blue: 0.678), // Light peach
                darkBackgroundColor: Color(red: 0.353, green: 0.204, blue: 0.067) // Rich dark bronze
            )
            
        */]
    }
}

extension URLRequest {
    static func createRequest(method: HTTPMethod, url: URL, body: Encodable? = nil, requiresAuthorization: Bool = false, requiresAuthentication: Bool = false, requiresAppAuthentication: Bool = false) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        /*if requiresAuthentication {
         guard let token = await KeychainManager.shared.getToken() else {
         return nil
         }
         request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         }*/
        
        /*if requiresAppAuthentication {
         guard let appToken = await getAppToken() else {
         return nil
         }
         request.setValue(appToken, forHTTPHeaderField: "App-Token")
         }*/
        
        if let body = body {
            guard let jsonData = try? JSONEncoder().encode(body) else {
                return nil
            }
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if requiresAuthorization {
            guard let body = body else {
                return nil
            }
            let credentials = "\(body)"
            guard let credentialData = credentials.data(using: .utf8) else {
                return nil
            }
            let base64Credentials = credentialData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
