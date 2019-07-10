//
//  Util.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/5/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setRounded(bordedColor: UIColor = #colorLiteral(red: 0.9691175818, green: 0.9630624652, blue: 0.9590174556, alpha: 1), borderWitdht: Int = 5) {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0.9691175818, green: 0.9630624652, blue: 0.9590174556, alpha: 1)
        self.clipsToBounds = true
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
}
