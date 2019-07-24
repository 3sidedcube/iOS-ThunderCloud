//
//  StormLanguageController+Locale.swift
//  ThunderCloud
//
//  Created by Ryan Bourne on 24/07/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import Foundation

extension StormLanguageController {
    
    /// The locales that the user prefers to view content in.
    internal var preferredLocales: [Locale]? {
        
        //Generate our preferred Locales based on the users preferences
        var preferredLocales = Locale.preferredLanguages.compactMap({ (languageString: String) -> Locale in
            return Locale(identifier: languageString)
        })
        
        // If the user has applied an override language to the app we need to retrieve a saved version and apply it as the app language
        // Check the defaults for the override language filename
        if let overridePackFileName = UserDefaults.standard.object(forKey: overrideLanguagePackSavingKey) as? String {
            
            // If we have the saved override filename, filter our available language packs for it
            let savedOverridePack = availableLanguagePacks?.first(where: { (pack) -> Bool in
                return pack.fileName == overridePackFileName
            })
            
            // If we find the pack lets insert it into our preferredLocales, and set the overrideLanguage Pack to the saved version
            if let savedOverridePack = savedOverridePack {
                preferredLocales.insert(savedOverridePack.locale, at: 0)
                overrideLanguagePack = savedOverridePack
            }
        }
        
        return preferredLocales
    }
    
    /// Returns a `Locale` for a storm language key
    ///
    /// - Parameter languageKey: The locale string as returned by the CMS
    /// - Returns: A `Locale` generated from the string
    public func locale(for languageKey: String) -> Locale? {
        
        return languagePack(forLocaleIdentifier: languageKey)?.locale
    }
    
    /// Returns a localised name for a language for a certain locale
    ///
    /// - Parameter locale: The locale to return the localised name for
    /// - Returns: Returns the name of the locale, loclaised to the locale
    public func localisedLanguageName(for locale: Locale) -> String? {
        
        return locale.localizedString(forIdentifier: locale.identifier)
    }
    
    /// Returns a localised name for a language for a certain locale identifier (i.e. en_US)
    ///
    /// - Parameter localeIdentifier: The locale id to return the localised name for
    /// - Returns: A string of the language name, in that language
    public func localisedLanguageName(for localeIdentifier: String) -> String? {
        let locale = Locale(identifier: localeIdentifier)
        return locale.localizedString(forIdentifier: locale.identifier)
    }
    
    /// The locale for the users currently selected language
    public var currentLocale: Locale? {
        guard let language = currentLanguage else {
            return nil
        }
        return locale(for: language)
    }
    
}
