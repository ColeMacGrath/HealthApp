//
//  Util.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/5/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import UIKit

enum MeasurementUnit: Int {
    case pound = 0
    case kilogram = 1
    case meter = 2
    case feet = 3
}

enum HealthValue: Int {
    case weight = 0
    case height = 1
    case hearth = 2
}

enum DateTermn: Int {
    case tinny
    case short
    case long
}

extension UIImageView {
    func setRounded(bordedColor: UIColor = #colorLiteral(red: 0.9691175818, green: 0.9630624652, blue: 0.9590174556, alpha: 1), borderWitdht: Int = 5) {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0.9691175818, green: 0.9630624652, blue: 0.9590174556, alpha: 1)
        self.clipsToBounds = true
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

extension UITextField {
    func useUnderline(color: UIColor = UIColor.lightGray, borderWidht: CGFloat = CGFloat(1.0)) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidht), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidht
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

@IBDesignable
class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}

extension Date {
    var day: Int {
        //Get Hour
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        let day = components.day
        
        //Return Hour
        return day!
    }
    
    func offsetFrom(date: Date, dateTerm: DateTermn) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        let shortHour = "\(difference.hour ?? 0)h"
        
        switch dateTerm {
        case .tinny:
            if let day = difference.day, day          > 0 { return seconds }
        case .short:
            if let hour = difference.hour, hour       > 0 { return shortHour }
        case .long:
            if let minute = difference.minute, minute > 0 { return days }
        }
        
        return ""
    }
    
    func hoursElapsed(date: Date) -> Int {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let hours = difference.hour ?? 0
        
        return hours
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var hourAndMinutes: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        return "\(hour):\(minutes)"
    }
    
    var shortDate: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    var iso8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}

extension Double {
    var withoutDecimals: String {
        return String(format: "%.0f", self)
    }
}

extension UITableView {
    func removeExtraLines() {
        self.tableFooterView = UIView()
    }
}

extension String {
    var createDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        return date
    }
}
