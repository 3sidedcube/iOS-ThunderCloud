//
//  PreferredLanguagesTests.swift
//  ThunderCloudTests
//
//  Created by Simon Mitchell on 28/02/2019.
//  Copyright © 2019 threesidedcube. All rights reserved.
//

import XCTest
@testable import ThunderCloud

extension Language {
    convenience init(languageId: String) {
        self.init(dictionary: [
            "languageIdentifier": languageId
        ])
    }
}

class PreferredLanguagesTests: XCTestCase {

    func testOrdersCorrectlyWithMultipleFullMatches() {
        
        let languages: [Language] = [
            Language(languageId: "usa_en"),
            Language(languageId: "usa_es")
        ]
        
        let sortedLanguages = languages.sortByPreference(using: ["usa_es", "usa_en"])
        XCTAssertEqual(sortedLanguages.flatMap({ $0.languageIdentifier }), ["usa_es", "usa_en"])
    }
    
    func testOrdersCorrectlyWithSingleFullMatch() {
        
        let languages: [Language] = [
            Language(languageId: "gb_en"),
            Language(languageId: "usa_es")
        ]
        
        let sortedLanguages = languages.sortByPreference(using: ["usa_es"])
        XCTAssertEqual(sortedLanguages.flatMap({ $0.languageIdentifier }), ["vi-US", "es-419"])
    }
    
    func testOrdersCorrectlyWithSinglePartialMatch() {
        
        let languages: [Language] = [
            Language(languageId: "gb_en"),
            Language(languageId: "usa_es")
        ]
        
        let sortedLanguages = languages.sortByPreference(using: ["usa_es"])
        XCTAssertEqual(sortedLanguages.flatMap({ $0.languageIdentifier }), ["usa_es", "gb_en"])
    }
}
