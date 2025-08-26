//
//  LanguageManager.swift
//  FindPhoneByClapWithSound
//
//  Created by Rambali Kumar on 20/08/25.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    
    private init() {}
    
    enum AppLanguage: String {
        case english = "en"
        case hindi = "hi"
        case gujarati = "gu"
    }
    
    var currentLanguage: AppLanguage {
        get {
            let lang = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
            return AppLanguage(rawValue: lang) ?? .english
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "appLanguage")
        }
    }
    
    func localizedString(for key: String) -> String {
        let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
}
