//
//  LanguagePack.swift
//  ThunderCloud
//
//  Created by Ryan Bourne on 24/07/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import Foundation
import ThunderTable

/// A struct to contain a locale object and the assosicated file name of the storm language file
public struct LanguagePack {
    
    /// The locale object representing the language pack
    public let locale: Locale
    
    /// The raw file name of the language (without .json extension)
    public let fileName: String
}

extension LanguagePack: Row {
    
    public var title: String? {
        return StormLanguageController.shared.localisedLanguageName(for: locale)
    }
    
    public var accessoryType: UITableViewCell.AccessoryType? {
        
        guard let currentLanguage = StormLanguageController.shared.currentLanguage else {
            return UITableViewCell.AccessoryType.none
        }
        
        if let overrideLanguageId = StormLanguageController.shared.overrideLanguagePack?.fileName, overrideLanguageId == fileName {
            return .checkmark
        } else if StormLanguageController.shared.overrideLanguagePack == nil && fileName == currentLanguage {
            return .checkmark
        }
        
        return UITableViewCell.AccessoryType.none
    }
}
