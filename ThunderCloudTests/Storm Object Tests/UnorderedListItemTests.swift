//
//  UnorderedListItemTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 07/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class UnorderedListItemTests: XCTestCase {
    
    /// returns expected class.
    func testCellClass_returnsCorrectClass() {
        let item = UnorderedListItem(dictionary: [:])
        
        XCTAssertTrue(item.cellClass == UnorderedListItemCell.self)
    }
    
    /// returns .none
    func testAccessoryType_returnsNone() {
        let item = UnorderedListItem(dictionary: [:])
        
        XCTAssertTrue(item.accessoryType == UITableViewCell.AccessoryType.none)
    }
    
    /// returns .none
    func testSelectionStyle_returnsNone() {
        let item = UnorderedListItem(dictionary: [:])
        
        XCTAssertTrue(item.selectionStyle == UITableViewCell.SelectionStyle.none)
    }
    
}
