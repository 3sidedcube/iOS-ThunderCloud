//
//  StormLanguageControllerStringsTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class StormLanguageControllerStringsTests: XCTestCase {
    
    static let emptyLanguageDictionary: [AnyHashable: Any] = [:]
    static let languageDictionary: [AnyHashable: Any] = [
        "test1": "value1",
        "test2": "value2",
        "test3": "value\\n\\t\\r"
    ]
    
    /// nil languageDictionary, returns key
    func testStringForKey_nilLanguageDictionary_returnsKey() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = nil
        
        XCTAssertTrue(controller.string(forKey: "key") == "key")
    }
    
    /// empty languageDictionary, returns key
    func testStringForKey_emptyLanguageDictionary_returnsKey() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.emptyLanguageDictionary
        
        XCTAssertTrue(controller.string(forKey: "key") == "key")
    }
    
    /// invalid key, returns key
    func testStringForKey_invalidKey_returnsKey() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(forKey: "key") == "key")
    }
    
    /// valid key, returns value for key
    func testStringForKey_validKey_returnsValueForKey() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(forKey: "test1") == "value1")
    }
    
    /// nil language dictionary, nil fallback string, returns nil
    func testStringForKeyWithFallbackString_nilLanguageDictionary_returnsNil() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = nil
        
        XCTAssertTrue(controller.string(forKey: "key", withFallback: nil) == nil)
    }
    
    /// nil language dictionary, non-nil fallback string, returns fallback string
    func testStringForKeyWithFallbackString_nilLanguageDictionary_returnsFallbackString() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = nil
        
        XCTAssertTrue(controller.string(forKey: "key", withFallback: "key1") == "key1")
    }
    
    /// empty language dictionary, returns fallback string
    func testStringForKeyWithFallbackString_emptyLanguageDictionary_returnsFallbackString() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.emptyLanguageDictionary
        
        XCTAssertTrue(controller.string(forKey: "key", withFallback: "key1") == "key1")
    }
    
    /// invalid key, returns fallback string
    func testStringForKeyWithFallbackString_invalidKey_returnsFallbackString() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(forKey: "key", withFallback: "key1") == "key1")
    }
    
    /// valid key, contains none of the replaceable occurences, returns unaltered value
    func testStringForKeyWithFallbackString_validKeyWithNoReplacements_returnsValue() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(forKey: "test1", withFallback: "fallback") == "value1")
    }
    
    /// valid key, contains replaceable occurences, returns altered value
    func testStringForKeyWithFallbackString_validKeyWithReplacements_returnsAlteredValue() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(forKey: "test3", withFallback: "fallback") == "value\n\t\r")
    }
    
    /// empty dictionary, returns nil
    func testStringForDictionary_emptyDictionary_returnsNil() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = nil
        
        XCTAssertTrue(controller.string(for: [:]) == nil)
    }
    
    /// dictionary doesn't contain content, returns nil
    func testStringForDictionary_noContent_returnsNil() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = nil
        
        XCTAssertTrue(controller.string(for: ["test": "value"]) == nil)
    }
    
    /// dictionary contains content, content is nil, returns nil
    func testStringForDictionary_contentIsNil_returnsNil() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(for: ["content": NSNull()]) == nil)
    }
    
    /// dictionary contains content, content is invalid, returns nil
    func testStringForDictionary_contentIsNotFoundInLanguageDictionary_returnsNil() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(for: ["content": "value"]) == nil)
    }
    
    /// dictionary contains content, content is found and is string, returns content
    func testStringForDictionary_contentIsFoundAndIsString_returnsContent() {
        let controller = StormLanguageController.shared
        controller.languageDictionary = StormLanguageControllerStringsTests.languageDictionary
        
        XCTAssertTrue(controller.string(for: ["content": "test1"]) == "value1")
    }
    
}
