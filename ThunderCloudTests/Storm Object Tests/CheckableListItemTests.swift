//
//  CheckableListItemTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class CheckableListItemTests: XCTestCase {
    
    static let dictionary: StormData = [
        "class": "CheckableListItemView",
        "id": 6183519,
        "title": [
            "class": "Text",
            "content": "f34tg"
        ],
        "volatile": false
    ]
    
    /// empty dictionary, empty object returned.
    func testInit_emptyDictionary_checkIdentifierNotSet() {
        let item = CheckableListItem(dictionary: [:])
        
        XCTAssertTrue(item.checkIdentifier == nil)
    }
    
    /// dictionary with invalid ID type, empty object returned.
    func testInit_invalidIDType_checkIdentifierNotSet() {
        var invalidDictionary = CheckableListItemTests.dictionary
        invalidDictionary["id"] = "6183519"
        
        let item = CheckableListItem(dictionary: invalidDictionary)
        
        XCTAssertTrue(item.checkIdentifier == nil)
    }
    
    /// dictionary with valid ID type, id is set.
    func testInit_validIDType_checkIdentifierNotSet() {
        let item = CheckableListItem(dictionary: CheckableListItemTests.dictionary)
        
        XCTAssertTrue(item.checkIdentifier == 6183519)
    }
    
    /// correct class is returned.
    func testCellClass_correctClassIsReturned() {
        let item = CheckableListItem(dictionary: CheckableListItemTests.dictionary)
        
        XCTAssertTrue(item.cellClass == EmbeddedLinksInputCheckItemCell.self)
    }
    
    /// correct accessoryType is returned.
    func testAccessoryType_correctTypeIsReturned() {
        let item = CheckableListItem(dictionary: CheckableListItemTests.dictionary)
        
        XCTAssertTrue(item.accessoryType == UITableViewCellAccessoryType.none)
    }
    
    /// correct selectionStyle is returned.
    func testSelectionStyle_correctStyleIsReturned() {
        let item = CheckableListItem(dictionary: CheckableListItemTests.dictionary)
        
        XCTAssertTrue(item.selectionStyle == .default)
    }
}
