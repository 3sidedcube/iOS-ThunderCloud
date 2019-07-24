//
//  StormLanguageController+RightToLeft.swift
//  ThunderCloud
//
//  Created by Ryan Bourne on 24/07/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import Foundation

extension StormLanguageController {
    
    /// Returns the correct text alignment for the user's current language setting for a given base text direction.
    ///
    /// - Parameter baseDirection: the base text direction to correct for the users current language setting
    /// - Returns: The correct direction for the given language
    public func localisedTextDirection(for baseDirection: NSTextAlignment) -> NSTextAlignment? {
        
        guard let languageCode = self.currentLocale?.languageCode else {
            return baseDirection
        }
        
        let languageDirection = Locale.characterDirection(forLanguage: languageCode)
        
        if baseDirection == .left {
            
            if languageDirection == .leftToRight {
                return .left
            } else if languageDirection == .rightToLeft {
                return .right
            }
            
        } else if baseDirection == .right {
            
            if languageDirection == .leftToRight {
                return .right
            } else if languageDirection == .rightToLeft {
                return .left
            }
        }
        
        return baseDirection
        
    }
    
    /// Returns whether the users current language is a right to left language
    public var isRightToLeft: Bool {
        
        guard let languageCode = self.currentLocale?.languageCode else {
            return false
        }
        
        let languageDirection = Locale.characterDirection(forLanguage: languageCode)
        
        if languageDirection == .rightToLeft {
            return true
        }
        
        return false
    }
    
}
