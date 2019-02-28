//
//  Language+Preferred.swift
//  ThunderCloud
//
//  Created by Simon Mitchell on 28/02/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import Foundation

extension Language {
    var isoIdentifier: String {
        
    }
}

extension Array where Element == Language {
    
    /// Sorts an array of storm languages using an array of language identifiers
    ///
    /// - Parameter languageIdentifiers: An array of language identifiers to be used to sort the languages (Defaults to `Locale.preferredLanguages`)
    /// - Returns: The sorted languages
    public func sortByPreference(using languageIdentifiers: [String] = Locale.preferredLanguages) -> [Language] {
        
        // Strip the preferred languages of their locales ["en-GB", "vi-US"] -> ["en", "vi"]
        let regionStrippedLanguageIdentifiers = languageIdentifiers.map({ $0.components(separatedBy: "-").first ?? $0 })
        
        // Sort the available languages by their position in `Locale.preferredLanguages`
        // Enumerate these so we can keep the original order whilst sorting if neither language is in `preferredLanguages`
        let sorted = enumerated().sorted(by: { (enumeration1, enumeration2) -> Bool in
            
            let language1 = enumeration1.element
            let language2 = enumeration2.element
            
            guard let languageId1 = language1.languageIdentifier else {
                return false
            }
            guard let languageId2 = language2.languageIdentifier else {
                return true
            }
            
            let index1 = languageIdentifiers.index(of: languageId1)
            let index2 = languageIdentifiers.index(of: languageId2)
            let partialIndex1 = regionStrippedLanguageIdentifiers.index(of: languageId1.components(separatedBy: "_").last ?? languageId1)
            let partialIndex2 = regionStrippedLanguageIdentifiers.index(of: languageId2.components(separatedBy: "_").last ?? languageId2)
            
            switch (index1, index2, partialIndex1, partialIndex2) {
            // If both have full match with preferred language, then sort by their ordering in preferred language
            case (.some(let _index1), .some(let _index2), _, _):
                return _index1 < _index2
            // If only first has full match or partial match with a preferred language then it comes first
            case (.some(_), nil, _, _), (nil, nil, .some(_), nil):
                return true
            // If only the second has full or partial match with a preferred language then it comes first
            case (nil, .some(_), _, _), (nil, nil, nil, .some(_)):
                return false
            // If both have *only* partial match then sort by their ordering in preferred language
            case (nil, nil, .some(let _partialIndex1), .some(let _partialIndex2)):
                return _partialIndex1 < _partialIndex2
            default:
                // Finally, keep them in the same order!
                return enumeration1.offset < enumeration2.offset
            }
            
        }).map({ $0.element })
        
        return sorted
    }
}
