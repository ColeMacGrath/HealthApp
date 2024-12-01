//
//  FloatingAlertView.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 31/12/23.
//

import UIKit

enum AlertType {
    case defaultAlert
    case success
    case warning
    case error
}

class FloatingAlertView: UIView {
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private var dismissTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 15
        self.clipsToBounds = false
        
        self.imageView.contentMode = .scaleAspectFill
        self.addSubview(self.imageView)
        
        self.textLabel.textAlignment = .center
        self.textLabel.textColor = .label
        self.addSubview(self.textLabel)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            self.imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 24),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor),
            
            self.textLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 8),
            self.textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            self.textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        self.addGestureRecognizer(panGesture)
        self.dismissTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        guard gesture.state == .ended else { return }
        self.dismissAlert()
    }
    
    @objc private func dismissAlert() {
        self.dismissTimer?.invalidate()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func configure(text: String, alertType: AlertType) {
        let color: UIColor = alertType == .error ? .white : .darkGray
        var image: UIImage?
        
        switch alertType {
        case .success:
            image = UIImage.sfSymbol("checkmark.circle.fill", color: color)
        case .warning:
            image = UIImage.sfSymbol("exclamationmark.triangle.fill", color: color)
        case .error:
            image = UIImage.sfSymbol("exclamationmark.octagon.fill", color: color)
        default: break
        }
        
        self.imageView.image = image
        self.textLabel.text = text
        self.textLabel.textColor = color
    }
}
