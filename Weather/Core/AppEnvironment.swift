//
//  AppEnvironment.swift
//  Weather
//
//  Created by Tomas Torres on 10/6/22.
//

import Foundation

class AppEnvironment {
    static func getSecretsConfigFile() -> NSDictionary? {
            guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path) else {
                      return NSDictionary()
                  }
            return dict
        }
        
        static func getSecretValueFor<T>(key: String) -> T? {
            guard let dict = getSecretsConfigFile(),
                  let secret = dict.value(forKey: key) as? T else {
                      return nil
                  }
            return secret
        }
}
