//
//  TextListItemTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class TextListItemTests: XCTestCase {
    
    let languageController = StormLanguageController.shared
    
    static let dictionary: StormData = [
        "class": "TextListItemView",
        "description": [
            "class": "Text",
            "content": "2k365"
        ]
    ]
    
    override func setUp() {
        super.setUp()
        
        StormLanguageController.shared.languageDictionary = [
            "2k365": "test"
        ]
    }
    /// empty dictionary, nothing set.
    func testInit_emptyDictionary_textNotSet() {
        let item = TextListItem(dictionary: [:])
        
        XCTAssertTrue(item.subtitle == nil)
    }
    
    /// dictionary contains invalid description type, no text is set.
    func testInit_dictionaryContainsInvalidTextObject_textNotSet() {
        var alteredDictionary = TextListItemTests.dictionary
        alteredDictionary["description"] = "text"
        
        let item = TextListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.subtitle == nil)
    }
    
    /// dictionary contains description, text is set.
    func testInit_dictionaryContainsText_textIsSet() {
        let item = TextListItem(dictionary: TextListItemTests.dictionary)
        
        XCTAssertTrue(item.subtitle == "test")
    }
    
    /// returns .none
    func testAccessoryType_returnsNone() {
        let item = TextListItem(dictionary: TextListItemTests.dictionary)
        
        XCTAssertTrue(item.accessoryType == UITableViewCell.AccessoryType.none)
    }
    
    /// returns .none
    func testSelectionStyle_returnsNone() {
        let item = TextListItem(dictionary: TextListItemTests.dictionary)
        
        XCTAssertTrue(item.selectionStyle == UITableViewCell.SelectionStyle.none)
    }
    
    /// returns correct class
    func testCellClass_returnsCorrectClass() {
        let item = TextListItem(dictionary: TextListItemTests.dictionary)
        
        XCTAssertTrue(item.cellClass == TextListItemCell.self)
    }
    
}
