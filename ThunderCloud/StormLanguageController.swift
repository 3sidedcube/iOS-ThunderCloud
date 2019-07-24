//
//  StormLanguageController.swift
//  ThunderCloud
//
//  Created by Matthew Cheetham on 02/06/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import Foundation
import UIKit

/// A controller that handles loading language files for Storm and provides methods to look up localisation strings.
/// To understand how this controller works you must first understand the difference between a Storm Locale and a `Locale`.
/// Storm Locales come in the format of "gbr_en" (Region, Language)
/// `Locale` comes in the format of "en_GB" (Language, Region)
/// `Locale` is able to ingest locales in the three letter format provided they are in the language_region format.
/// This controller often re-organises the Storm file names to be in the language_region format before converting to `Locale`, once these are converted to `Locale` they can easily be compared with `Locale`s from the users device to find a match.
open class StormLanguageController: NSObject {
    
    public static let shared = StormLanguageController()
    
    /// The dictionary of keys and values used for looking up language values for localisations.
    public var languageDictionary: [AnyHashable: Any]?
    
    /// The current language identifier
    public var currentLanguage: String?
    
    /// The users langauge that they have forced as an overide. Usually different from the current device locale
    @available(*, deprecated, message: "Language is deprecated use overrideLanguagePack instead")
    public var overrideLanguage: Language?
    
    /// The users language they have chosen as an override to the default device locale, replaces overrideLanguage
    public var overrideLanguagePack: LanguagePack?
    
    /// Key used to save and retrieve an override language pack
    internal let overrideLanguagePackSavingKey = "TSCLanguagePackOverrideFileName"
    
    // Private init as only the shred instance should be used
    public override init() {
        super.init()
        migrateToLanguagePackIfRequired()
    }
    
    /// Loads the contents of a language file at a specific url and sets it as the current language dictionary
    ///
    /// - Parameter filePath: The full url path of the .json language file to load
    func loadLanguageFile(fileURL: URL) {
        
        print("<ThunderStorm> [Languages] Loading language at path \(fileURL)")
        
        let languageContent = languageDictionary(for: fileURL)
        
        if let languageContent = languageContent {
            languageDictionary = languageContent
        } else {
            print("<ThunderStorm> [Languages] No data for language pack")
        }
    }
    
    /// Loads a language dictionary from a file path
    ///
    /// - Parameter filePath: The url of the file to load the language from
    /// - Returns: A dictionary with the key values of localisations if one was available from disc
    func languageDictionary(for fileURL: URL) -> [AnyHashable: Any]? {
        
        let languageFileDictionary = try? JSONSerialization.jsonObject(with: fileURL)
        
        if let languageFileDictionary = languageFileDictionary as? [AnyHashable: Any] {
            return languageFileDictionary
        }
        
        return nil
    }
    
    /// All available languages found in the current storm driven app
    ///
    /// - Returns: An array of TSCLanguage objects
    public func availableStormLanguages() -> [Language]? {
        
        let languageFiles = ContentController.shared.fileNames(inDirectory: "languages")?.sorted()
        
        return languageFiles?.compactMap({ (fileName: String) -> Language? in
            
            let lang = Language()
            lang.localisedLanguageName = localisedLanguageName(for: fileName)
            let components = fileName.components(separatedBy: ".")
            lang.languageIdentifier = components.first
            return lang
        })
    }
    
    /// Confirms that the user wishes to switch the language to the current string set at as overrideLanguage
    public func confirmLanguageSwitch() {
        
        let defaults = UserDefaults.standard
        
        if let overrideLanguagePack = overrideLanguagePack {
            defaults.set(overrideLanguagePack.fileName, forKey: overrideLanguagePackSavingKey)
            
            NotificationCenter.default.sendAnalyticsHook(.switchLanguage(overrideLanguagePack))
        }
        
        reloadLanguagePack()
        
        BadgeController.shared.reloadBadgeData()
        
        // Re-index because we've changed language so we want core spotlight in correct language
        ContentController.shared.indexAppContent { (error: Error?) -> (Void) in
            
            // If we get an error mark the app as not indexed
            if let _ = error {
                defaults.set(false, forKey: "TSCIndexedInitialBundle")
            }
        }
        
        NotificationCenter.default.post(name: .languageSwitchedNotification, object: self, userInfo: nil)
        
        
        let appView = AppViewController()
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = appView
    }
    
    //MARK: - Loop methods
    
    /// The localised string for the required key.
    ///
    /// - Parameter key: The key for which a localised string should be returned.
    /// - Returns: Returns the localised string for the required key.
    public func string(forKey key: String) -> String? {
        return string(forKey: key, withFallback: key)
    }
    
    /// The localised string for the required key, with a fallback string if a localisation cannot be found in the key-value pair dictionary of localised strings
    ///
    /// - Parameters:
    ///   - key: The key for which a localised string should be returned.
    ///   - fallbackString: The fallback string to be used if the string doesn't exist in the key-value pair dictionary.
    /// - Returns: A string of either the localisation or the fallback string
    public func string(forKey key: String, withFallback fallbackString: String?) -> String? {
        
        guard let languageDictionary = languageDictionary, var string = languageDictionary[key] as? String else {
            return fallbackString
        }
        
        if !string.isEmpty {
            
            string = string.replacingOccurrences(of: "\\n", with: "\n")
            string = string.replacingOccurrences(of: "\\t", with: "\t")
            string = string.replacingOccurrences(of: "\\r", with: "\r")
            string = string.replacingOccurrences(of: "\\/", with: "/")
            string = string.replacingOccurrences(of: "\\\"", with: "\"")
        }
        
        return string
    }
    
    /// Returns the correct localised string for a Storm text dictionary.
    ///
    /// - Parameter dictionary: The Storm text dictionary to pull a string out of.
    /// - Returns: A localised string if found, if not you will get nil
    open func string(for dictionary: [AnyHashable: Any]) -> String? {
        
        guard let contentKey = dictionary["content"] as? String else {
            return nil
        }
        
        return string(forKey: contentKey, withFallback: nil)
    }
    
    /// A string representing the currently set language short key.
    public var currentLanguageShortKey: String? {
        return currentLocale?.languageCode
    }
}

public extension NSNotification.Name {
    static let languageSwitchedNotification = Notification.Name("TSCLanguageSwitchedNotification")
}
