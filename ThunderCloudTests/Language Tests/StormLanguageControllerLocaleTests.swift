//
//  StormLanguageControllerLocaleTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 05/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class StormLanguageControllerLocaleTests: XCTestCase {
    
    /// currentLanguage is nil - return nil.
    func test_currentLocale_currentLanguageIsNil_returnNil() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = nil
        
        XCTAssertTrue(controller.currentLocale == nil)
    }
    
    /// currentLanguage is empty - return nil.
    func test_currentLocale_currentLanguageIsEmpty_returnNil() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = ""
        
        XCTAssertTrue(controller.currentLanguageShortKey == nil)
    }
    
    /// currentLangauge is major only code (eng) - return eng locale.
    func test_currentLocale_currentLanguageIsMajorOnlyCode_returnCorrectLocale() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "eng"
        
        XCTAssertTrue(controller.currentLanguageShortKey == "en")
    }
    
    /// currentLanguage is major and minor code (eng_usa) - return eng_usa locale key.
    func test_currentLocale_currentLanguageIsMajorAndMinorCode_returnCorrectLocale() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "eng_usa"
        
        XCTAssertTrue(controller.currentLanguageShortKey == "usa")
    }
    
    /// Locale with no identifier - returns ?
    func test_localisedLanguageNameForLocale_localeWithNoIdentifier_returnsNil() {
        let controller = StormLanguageController.shared
        let locale = Locale(identifier: "")
        
        XCTAssertTrue(controller.localisedLanguageName(for: locale) == nil)
    }
    
    /// Locale with valid identifier - returns localised string.
    func test_localisedLanguageNameForLocale_withValidIdentifier_returnsCorrectName() {
        let controller = StormLanguageController.shared
        let locale = Locale(identifier: "en")
        
        XCTAssertTrue(controller.localisedLanguageName(for: locale) == "English")
    }
    
    /// Locale with invalid identifier - returns ?
    func test_localisedLanguageNameForLocaleIdentifier_withNoIdentifier_returnsNil() {
        let controller = StormLanguageController.shared
        
        XCTAssertTrue(controller.localisedLanguageName(for: "") == nil)
    }
    
    /// Locale with valid identifier - returns localised string.
    func test_localisedLanguageNameForLocaleIdentifier_withValidIdentifier_returnsCorrectName() {
        let controller = StormLanguageController.shared
        
        XCTAssertTrue(controller.localisedLanguageName(for: "en") == "English")
    }
    
    /// Language is spa - return es.
    func test_preprocessedLanguage_languageIsSpa_returnEs() {
        let controller = StormLanguageController.shared
        
        XCTAssertTrue(controller.preprocessed(language: "spa") == "es")
    }
    
    /// Language is eng - return eng.
    func test_preprocessedLanguage_languageIsEng_returnEng() {
        let controller = StormLanguageController.shared
        
        XCTAssertTrue(controller.preprocessed(language: "eng") == "eng")
    }
    
    /// Language is es - return es.
    func test_preprocessedLanguage_languageIsEs_returnEs() {
        let controller = StormLanguageController.shared
        
        XCTAssertTrue(controller.preprocessed(language: "es") == "es")
    }
    
}
