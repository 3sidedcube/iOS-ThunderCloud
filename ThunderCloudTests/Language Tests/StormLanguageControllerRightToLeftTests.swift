//
//  StormLanguageControllerRightToLeftTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class StormLanguageControllerRightToLeftTests: XCTestCase {
    
    /// currentLocale is nil, return base direction.
    func testLocalisedTextDirection_currentLocaleIsNil_returnBaseDirection() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = nil
        
        XCTAssertTrue(controller.localisedTextDirection(for: .left) == .left)
    }
    
    /// currentLocale is invalid, base direction is left, return left.
    func testLocalisedTextDirection_currentLocaleIsInvalid_baseDirectionIsLeft_returnLeft() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "1"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .left) == .left)
    }
    
    /// currentLocale is invalid, base direction is right, return right.
    func testLocalisedTextDirection_currentLocaleIsInvalid_baseDirectionIsRight_returnRight() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "1"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .right) == .right)
    }
    
    /// currentLocale is en, base direction is left, return left
    func testLocalisedTextDirection_currentLocaleIsEN_baseDirectionIsLeft_returnLeft() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "eng"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .left) == .left)
    }
    
    /// currentLocale is en, baseDirection is right, return right
    func testLocalisedTextDirection_currentLocaleIsEN_baseDirectionIsRight_returnRight() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "eng"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .right) == .right)
    }
    
    /// currentLocale is ara, baseDirection is left, return right
    func testLocalisedTextDirection_currentLocaleIsAra_baseDirectionIsLeft_returnRight() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "ara"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .left) == .right)
    }
    
    /// currentLocale is ara, baseDirection is right, return left
    func testLocalisedTextDirection_currentLocaleIsAra_baseDirectionIsRight_returnLeft() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "ara"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .right) == .left)
    }
    
    /// currentLocale is en, base direction is center, return center
    func testLocalisedTextDirection_currentLocaleIsEn_baseDirectionIsCenter_returnCenter() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "eng"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .center) == .center)
    }
    
    /// currentLocale is ara, base direction is center, return center
    func testLocalisedTextDirection_currentLocaleIsAra_baseDirectionIsCenter_returnCenter() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "ara"
        
        XCTAssertTrue(controller.localisedTextDirection(for: .center) == .center)
    }
    
    /// currentLocale is nil, return false
    func testIsRightToLeft_currentLocaleIsNil_returnFalse() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = nil
        
        XCTAssertTrue(controller.isRightToLeft == false)
    }
    
    /// currentLocale is invalid, return false
    func testIsRightToLeft_currentLocaleIsInvalid_returnFalse() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = ""
        
        XCTAssertTrue(controller.isRightToLeft == false)
    }
    
    /// currentLocale is en, return false
    func testIsRightToLeft_currentLocaleIsEN_returnFalse() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "en"
        
        XCTAssertTrue(controller.isRightToLeft == false)
    }
    
    /// currentLocale is ara, return true
    func testIsRightToLeft_currentLocaleIsAra_returnTrue() {
        let controller = StormLanguageController.shared
        controller.currentLanguage = "ara"
        
        XCTAssertTrue(controller.isRightToLeft == true)
    }
    
}
