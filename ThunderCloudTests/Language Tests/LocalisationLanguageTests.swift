//
//  LocalisationLanguageTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class LocalisationLanguageTests: XCTestCase {
    
    static let dictionary: StormData = [
        "id": "12345",
        "code": "eng",
        "name": "English",
        "publishable": true
    ]
    
    /// empty dictionary, all nil apart from languageCode.
    func testInit_withEmptyDictionary_allNilExceptLanguageCode() {
        let languageObject = LocalisationLanguage(dictionary: [:])
        
        XCTAssertTrue(languageObject.uniqueIdentifier == nil)
        XCTAssertTrue(languageObject.languageCode == "")
        XCTAssertTrue(languageObject.languageName == nil)
        XCTAssertTrue(languageObject.isPublishable == false)
    }
    
    /// nil dictionary objects, all nil apart from languageCode.
    func testInit_withNilDictionaryObjects_allNilExceptLanguageCode() {
        let languageObject = LocalisationLanguage(dictionary: [
            "id": NSNull(),
            "code": NSNull(),
            "name": NSNull(),
            "publishable": NSNull()
        ])
        
        XCTAssertTrue(languageObject.uniqueIdentifier == nil)
        XCTAssertTrue(languageObject.languageCode == "")
        XCTAssertTrue(languageObject.languageName == nil)
        XCTAssertTrue(languageObject.isPublishable == false)
    }
    
    /// incorrect dictionary object types, all nil apart from languageCode.
    func testInit_withInvalidDictionaryObjects_allNilApartFromLanguageCode() {
        let languageObject = LocalisationLanguage(dictionary: [
            "id": 12345,
            "code": 12345,
            "name": 12345,
            "publishable": "true"
        ])
        
        XCTAssertTrue(languageObject.uniqueIdentifier == nil)
        XCTAssertTrue(languageObject.languageCode == "")
        XCTAssertTrue(languageObject.languageName == nil)
        XCTAssertTrue(languageObject.isPublishable == false)
    }
    
    /// correct dictionary object types, all present.
    func testInit_withValidDictionaryObjects_allNonNil() {
        let languageObject = LocalisationLanguage(dictionary: LocalisationLanguageTests.dictionary)
        
        XCTAssertTrue(languageObject.uniqueIdentifier == "12345")
        XCTAssertTrue(languageObject.languageCode == "eng")
        XCTAssertTrue(languageObject.languageName == "English")
        XCTAssertTrue(languageObject.isPublishable == true)
    }
    
}
