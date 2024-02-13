//
//  CacheImageView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-02-11.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CacheImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageFrom(url: URL?) {
        guard let url else { return }
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            DispatchQueue.main.async {
                guard let data,
                      let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                self.image = imageToCache
            }
        }.resume()
    }
}
