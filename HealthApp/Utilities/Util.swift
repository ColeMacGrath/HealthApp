//
//  Util.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import Foundation
import UIKit

extension UIImage {
    static func sfSymbol(_ symbolName: String, color: UIColor) -> UIImage {
        guard let symbolImage = UIImage(systemName: symbolName) else { return UIImage() }
        let coloredImage = symbolImage.withTintColor(color, renderingMode: .alwaysOriginal)
        return coloredImage
    }
}

extension UIStoryboard {
    static func getViewControllerWith(identifier: String) -> UIViewController? {
        UIStoryboard().instantiateViewController(withIdentifier: identifier)
    }
}

extension UINavigationItem {
    func setCircularImage(image: UIImage, rigthItem: Bool) {
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 40, 40)
        
        UIGraphicsBeginImageContextWithOptions(button.frame.size, false, image.scale)
        let rect  = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)
        UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2).addClip()
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let color = UIColor(patternImage: newImage)
        button.backgroundColor = color
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.rightBarButtonItem = barButton
    }
}

extension UIImageView {
    func setCircularImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func downloadImage(from url: URL?) {
        guard let url else { return }
        if let cachedImage = URLCache.shared.cachedResponse(for: URLRequest(url: url))?.data,
            let image = UIImage(data: cachedImage) {
                DispatchQueue.main.async {
                    self.image = image
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == HTTPStatusCode.success.rawValue,
                      let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                      let data = data, error == nil,
                      let image = UIImage(data: data) else { return }
                
                let cachedData = CachedURLResponse(response: httpURLResponse, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
}

extension UINavigationController {
    func cleanNavigation() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
        
        // Hide title and back button text, but keep the back arrow
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Ensure swipe back gesture is enabled
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func defaultNavigation() {
        // Restore the navigation bar to its original state
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = nil  // Set this to your default color if needed
    }
    
    func setMinimalBackButton() {
        self.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

extension UIEdgeInsets {
    mutating func removeSeparator() {
        self = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    mutating func addSeparator() {
        self = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

extension Date {
    static var today: Date? {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self.init())
    }
    
    func differenceBetween(date: Date) -> (hours: Int, minutes: Int)? {
        let firstDate = self
        let seconDate = date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: firstDate, to: seconDate)
        guard let hours = components.hour,
              let minutes = components.minute else { return nil }
        
        return (hours, minutes)
    }
    
    func onPast(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
    
    var twelveHoursFormmatedHour: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        return timeFormatter.string(from: self)
    }
    
    var abbreviatedMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

extension String {
    static var empty: String{
        return String()
    }
}

extension UIFont {
    enum FontVariation: String {
        case light = "Light"
        case medium = "Medium"
        case bold = "Bold"
    }
}

extension UIViewController {
    var safeAreaHeight: CGFloat {
        let safeAreaTopInset = view.safeAreaInsets.top
        let safeAreaBottomInset = view.safeAreaInsets.bottom
        return view.bounds.height - safeAreaTopInset - safeAreaBottomInset
    }
    
    func showFloatingAlert(text: String, alertType: AlertType = . defaultAlert) {
        let alertView = FloatingAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        alertView.configure(text: text, alertType: alertType)
        switch alertType {
        case .defaultAlert:
            alertView.backgroundColor = .systemBackground
        case .success:
            alertView.backgroundColor = .green
        case .warning:
            alertView.backgroundColor = .yellow
        case .error:
            alertView.backgroundColor = .red
        }
        
        self.view.addSubview(alertView)
        self.view.bringSubviewToFront(alertView)
        alertView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            alertView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}

extension Int {
    static var aDay: Int { return 1 }
    static var week: Int { return 7 }
    static var year: Int { return 365 }
    func toRomanNumeral() -> String? {
        guard self > 0 && self < 4000 else {
            return nil
        }
        
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        let romanNumeral = arabicValues.enumerated().reduce(("", self)) { (result, pair) in
            var (roman, remaining) = result
            let (index, arabicValue) = pair
            while remaining >= arabicValue {
                roman += romanValues[index]
                remaining -= arabicValue
            }
            return (roman, remaining)
        }.0
        
        return romanNumeral
    }
}

extension Data {
    init(from integer: Int) {
        var int = integer
        self = Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    static func toInteger(data: Data) -> Int {
        return data.withUnsafeBytes { $0.load(as: Int.self) }
    }
}

extension UIButton {
    private struct AssociatedKeys {
        static var activityIndicator: UInt8 = 0
        static var originalTitle: UInt8 = 0
    }

    private var activityIndicator: UIActivityIndicatorView? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showLoading() {
        activityIndicator?.removeFromSuperview()
        let newActivityIndicator = UIActivityIndicatorView(style: .medium)
        newActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newActivityIndicator)

        let indicatorHeight = 20.0 // or whatever size you prefer
        let indicatorWidth = 20.0  // same as height for a square indicator

        NSLayoutConstraint.activate([
            newActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            newActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            newActivityIndicator.heightAnchor.constraint(equalToConstant: CGFloat(indicatorHeight)),
            newActivityIndicator.widthAnchor.constraint(equalToConstant: CGFloat(indicatorWidth))
        ])

        newActivityIndicator.startAnimating()
        self.setTitle("", for: .normal)
    }

    func hideLoading(title: String) {
        activityIndicator?.stopAnimating()
        self.setTitle(title, for: .normal)
    }
}
