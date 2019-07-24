//
//  LanguageTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 24/07/2019.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest
@testable import ThunderCloud

class LanguageTests: XCTestCase {
    
    /// Init with no dictionary - all is nil - de/encoding fails safely.
    func test_noDictionary_allIsNil() {
        let language = Language()
        
        expect(language: language, toContain: nil, languageIdentifier: nil)
        expectEncoded(language: language, toContain: nil, languageIdentifier: nil)
    }
    
    /// Init with dictionary - dictionary is empty - all is nil - de/encoding fails safely.
    func test_dictionaryIsEmpty_allIsNil() {
        let language = Language(dictionary: [:])
        
        expect(language: language, toContain: nil, languageIdentifier: nil)
        expectEncoded(language: language, toContain: nil, languageIdentifier: nil)
    }
    
    /// Init with dictionary - dictionary contains nil objects - all is nil - de/encoding fails safely
    func test_dictionaryContainsNilInfo_allIsNil() {
        let language = Language(dictionary: [
            "localisedLanguageName": NSNull(),
            "languageIdentifier": NSNull()
        ])
        
        expect(language: language, toContain: nil, languageIdentifier: nil)
        expectEncoded(language: language, toContain: nil, languageIdentifier: nil)
    }
    
    /// Init with dictionary - dictionary keys are wrong types - all is nil - de/encoding fails safely
    func test_dictionaryContainsWrongTypes_allIsNil() {
        let language = Language(dictionary: [
            "localisedLanguageName": 1,
            "languageIdentifier": 1
        ])
        
        expect(language: language, toContain: nil, languageIdentifier: nil)
        expectEncoded(language: language, toContain: nil, languageIdentifier: nil)
    }
    
    /// Init with dictionary - dictionary keys are correct types - all is valid - de/encoding works.
    func test_dictionaryContainsValidData_varsAreSet() {
        let language = Language(dictionary: [
            "localisedLanguageName": "testName",
            "languageIdentifier": "test"
        ])
        
        expect(language: language, toContain: "testName", languageIdentifier: "test")
        expectEncoded(language: language, toContain: "testName", languageIdentifier: "test")
    }
    
    /// No current language or languageId - return .none.
    func test_noCurrentLanguageOrLanguageID_returnNone() {
        XCTAssertTrue(Language().accessoryType(with: nil, overrideLanguageID: nil, languageId: nil) == .none)
    }
    
    /// No override language, languageID doesn't match current language - return .none.
    func test_noOverrideLanguage_languageIDDoesNotMatchCurrentLanguage_returnNone() {
        XCTAssertTrue(Language().accessoryType(with: "eng", overrideLanguageID: nil, languageId: "fre") == .none)
    }
    
    /// Override language doesn't match languageIdentifier but languageIdentifier matches currentLanguage - return .checkmark.
    func test_overrideLanguageOnlyMatchesCurrentLanguage_returnNone() {
        XCTAssertTrue(Language().accessoryType(with: "fre", overrideLanguageID: "eng", languageId: "fre") == .checkmark)
    }
    
    /// Override language matches language identifier - return .checkmark.
    func test_overrideLanguageMatchesLanguageIdentifier_returnCheckmark() {
        XCTAssertTrue(Language().accessoryType(with: "eng", overrideLanguageID: "fre", languageId: "fre") == .checkmark)
    }
    
    /// Nothing matches, .return none.
    func test_nothingMatches_returnNone() {
        XCTAssertTrue(Language().accessoryType(with: "eng", overrideLanguageID: "fre", languageId: "spa") == .none)
    }
    
    func expect(language: Language, toContain localisedLanguageName: String?, languageIdentifier: String?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(language.localisedLanguageName == localisedLanguageName, file: file, line: line)
        XCTAssertTrue(language.languageIdentifier == languageIdentifier, file: file, line: line)
        XCTAssertTrue(language.title == localisedLanguageName, file: file, line: line)
    }
    
    func expectEncoded(language: Language, toContain localisedLanguageName: String?, languageIdentifier: String?, file: StaticString = #file, line: UInt = #line) {
        let encodedLanguage = NSKeyedArchiver.archivedData(withRootObject: language)
        let decodedLanguage = NSKeyedUnarchiver.unarchiveObject(with: encodedLanguage) as? Language
        
        XCTAssertTrue(decodedLanguage?.localisedLanguageName == localisedLanguageName, file: file, line: line)
        XCTAssertTrue(decodedLanguage?.languageIdentifier == languageIdentifier, file: file, line: line)
        XCTAssertTrue(decodedLanguage?.title == localisedLanguageName, file: file, line: line)
    }
}
