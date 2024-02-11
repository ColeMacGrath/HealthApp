//
//  Config.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 03/01/24.
//

import Foundation

class Config {
    static func getPropertieListValue(forKey key: String, in prpertyList: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: prpertyList, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: key) as? String else {
            return nil
        }
        return value
    }
}
