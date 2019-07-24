//
//  StormLanguageController+LanguagePack.swift
//  ThunderCloud
//
//  Created by Ryan Bourne on 24/07/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import Foundation

extension StormLanguageController {
    
    /// The locales that are available in the language packs
    public var availableLanguagePacks: [LanguagePack]? {
        
        let availableLocaleFileNames = ContentController.shared.fileNames(inDirectory: "languages")
        
        if let availableLocaleFileNames = availableLocaleFileNames {
            
            return availableLocaleFileNames.compactMap({ (fileName: String) -> LanguagePack? in
                return languagePack(for: fileName)
            })
        }
        return nil
    }
    
    /// Unfortunately some language codes do not get ingested well by iOS, as their three letter and two letter country codes conflict somewhere internally so iOS gets confused and just represents the locale as a string instead of a real locale. This method will switch the language code out for something more compatible with iOS
    ///
    /// - Parameter language: The language code to check for conflicts
    /// - Returns: The new, compatible language code
    internal func preprocessed(language: String) -> String {
        
        if language == "spa" {
            return "es"
        }
        
        return language
    }
    
    /// Reloads the language pack based on user preferences and assigns it to the language dictionary
    public func reloadLanguagePack() {
        
        //Load languages
        var finalLanguage = [AnyHashable: Any]()
        
        var packs: (regionalLanguagePack: LanguagePack?, majorLanguagePack: LanguagePack?)? = nil
        
        if let languagePacks = availableLanguagePacks, let preferredLocales = preferredLocales {
            packs = preferredLanguagePacks(from: languagePacks, using: preferredLocales)
        }
        
        //Major
        let majorPack = packs?.majorLanguagePack
        
        if let majorFileName = majorPack?.fileName, let majorPackPath = ContentController.shared.fileUrl(forResource: majorFileName, withExtension: "json", inDirectory: "languages") {
            
            currentLanguage = majorFileName
            
            let majorLanguageDictionary = languageDictionary(for: majorPackPath)
            
            if let majorLanguageDictionary = majorLanguageDictionary {
                
                for (key, value) in majorLanguageDictionary {
                    finalLanguage[key] = value as Any
                }
            }
        }
        
        //Minor
        let minorPack = packs?.regionalLanguagePack
        if let minorFileName = minorPack?.fileName, let minorPackPath = ContentController.shared.fileUrl(forResource: minorFileName, withExtension: "json", inDirectory: "languages") {
            
            currentLanguage = minorFileName
            
            let minorLanguageDictionary = languageDictionary(for: minorPackPath)
            
            if let minorLanguageDictionary = minorLanguageDictionary as? [String: String] {
                
                for (key, value) in minorLanguageDictionary {
                    finalLanguage[key] = value as Any
                }
            }
        }
        
        //Fall back to default if we need it
        if finalLanguage.count == 0 {
            
            if let appFileURL = ContentController.shared.fileUrl(forResource: "app", withExtension: "json", inDirectory: nil) {
                
                let appJSON = try? JSONSerialization.jsonObject(with:appFileURL)
                
                if let _appJSON = appJSON as? [AnyHashable: Any], let packString = _appJSON["pack"] as? String, let packURL = URL(string: packString) {
                    
                    //Example of "PackString" `//languages/eng.json`
                    //We're trying to get the "eng" bit of it.
                    guard let fileName = packURL.lastPathComponent.components(separatedBy: ".").first, let fullFilePath = ContentController.shared.fileUrl(forResource: fileName, withExtension: "json", inDirectory: "languages") else {
                        return
                    }
                    
                    currentLanguage = fileName
                    self.languageDictionary = languageDictionary(for: fullFilePath)
                    return
                }
            }
        }
        
        //Final last ditch attempt at loading any language
        if finalLanguage.count == 0 {
            
            let allLanguages = availableStormLanguages()?.sortByPreference()
            
            if let firstLanguage = allLanguages?.first, let languageIdentifier = firstLanguage.languageIdentifier {
                
                let filePath = ContentController.shared.fileUrl(forResource: languageIdentifier, withExtension: "json", inDirectory: "languages")
                
                currentLanguage = languageIdentifier
                
                if let _filePath = filePath {
                    languageDictionary = languageDictionary(for: _filePath)
                    return
                }
            }
        }
        
        self.languageDictionary = finalLanguage
    }
    
    public func languagePack(for fileName: String) -> LanguagePack? {
        
        if let languageName = fileName.components(separatedBy: ".").first {
            return self.languagePack(forLocaleIdentifier: languageName)
        }
        
        return nil
    }
    
    public func languagePack(forLocaleIdentifier localeIdentifier: String) -> LanguagePack? {
        
        // Seperate region and langauge if there is a seperator
        let components = localeIdentifier.components(separatedBy: "_")
        
        // Get the first and last components from the array, if there is only 1 value these will be the same object
        if let languageString = components.last,
            let regionString = components.first {
            
            // if they aren't the same object we have a region AND a language
            if languageString != regionString {
                let fixedIdentifier = "\(preprocessed(language: languageString))_\(regionString)"
                return LanguagePack(locale: Locale(identifier: fixedIdentifier), fileName: localeIdentifier)
            } else {
                // Otherwise we only have a language
                return LanguagePack(locale: Locale(identifier: preprocessed(language: languageString)), fileName: localeIdentifier)
            }
        }
        
        return nil
    }
    
    func migrateToLanguagePackIfRequired() {
        
        //Add override locales if they exist
        if let overrideObject = UserDefaults.standard.object(forKey: "TSCLanguageOverride") as? Data, let overrideLanguage = NSKeyedUnarchiver.unarchiveObject(with: overrideObject) as? Language {
            
            // Migrate the languageOverride to languagePack
            if let pack = languagePack(for: overrideLanguage) {
                UserDefaults.standard.set(pack.fileName, forKey: overrideLanguagePackSavingKey)
                
                // Clean up saved deprecated TSCLanguage override
                // Set the previous value saved value to nil
                UserDefaults.standard.set(nil, forKey: "TSCLanguageOverride")
            }
        }
    }
    
    /// Converts a TSCLanguage object into the new LanguagePack Format
    ///
    /// - Parameter langauge: a TSCLanguage that needs to be converted
    /// - Returns: a new LanguagePack object that represents the same data as the TSCLangauge or nil
    func languagePack(for language: Language) -> LanguagePack? {
        
        // Check the language has a languageIdentifier
        guard let languageIdentifier = language.languageIdentifier else { return nil }
        
        // Add .json to identifier to get the filename
        let fileName =  languageIdentifier
        
        // Create a locale from the identifier
        let locale = Locale(identifier: languageIdentifier)
        
        // Create the pack using the 2 properties
        let pack = LanguagePack(locale: locale, fileName: fileName)
        return pack
    }
    
    /// Works out the major and regional language packs that are most suitable for the provided available packs and the user's preferred locales
    ///
    /// - Parameters:
    ///   - availablePacks: The language packs that are available to the app
    ///   - preferredLocales: The user's preferred locales
    /// - Returns: A tuple containing regional and major language packs. Regional is optional where major should always return one of the packs
    func preferredLanguagePacks(from availablePacks: [LanguagePack], using preferredLocales: [Locale]) -> (regionalLanguagePack: LanguagePack?, majorLanguagePack: LanguagePack?) {
        
        var regionalLanguagePack: LanguagePack?
        var majorLanguagePack: LanguagePack?
        
        //Find our language packs that match
        
        for preferredLocale in preferredLocales {
            
            for pack in availablePacks {
                
                // Matches both language and region
                if preferredLocale.languageCode == pack.locale.languageCode &&
                    pack.locale.regionCode != nil &&
                    preferredLocale.regionCode == pack.locale.regionCode {
                    
                    regionalLanguagePack = pack
                    
                    //Set the major language if it matches
                    if let languageCode = pack.fileName.components(separatedBy: "_").last {
                        let languageOnlyLocale = Locale(identifier: languageCode)
                        majorLanguagePack = LanguagePack(locale: languageOnlyLocale, fileName: languageCode)
                    }
                    
                    return (regionalLanguagePack: regionalLanguagePack, majorLanguagePack: majorLanguagePack)
                    
                    // Only matches language, and if majorLanguage has not already been set
                } else if preferredLocale.languageCode == pack.locale.languageCode,
                    majorLanguagePack == nil {
                    
                    //Set the major language if only the language matches. Major language pack always exists if a minor one exists
                    if let languageCode = pack.locale.languageCode, let languageName = pack.fileName.components(separatedBy: "_").first {
                        majorLanguagePack = LanguagePack(locale: Locale(identifier: languageCode), fileName: languageName)
                    }
                }
            }
        }
        
        return (regionalLanguagePack: regionalLanguagePack, majorLanguagePack: majorLanguagePack)
    }
    
}
