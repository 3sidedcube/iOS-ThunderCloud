//
//  EmbeddedLinksListItemTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class EmbeddedLinksListItemTests: XCTestCase {
    
    static let link: StormData = [
        "class": "ExternalLink",
        "destination": "http://www.google.com",
        "title": [
            "class": "Text",
            "content": "f20qf"
        ]
    ]
    
    static let dictionary: StormData = [
        "embeddedLinks": [
            EmbeddedLinksListItemTests.link
        ]
    ]
    
    /// empty dictionary, no links.
    func testInit_withEmptyDictionary_noLinksAdded() {
        let object = EmbeddedLinksListItem(dictionary: [:])
        
        XCTAssertTrue(object.embeddedLinks == nil)
    }
    
    /// embeddedLinks is wrong type, no links.
    func testInit_withInvalidDictionary_noLinksAdded() {
        let object = EmbeddedLinksListItem(dictionary: [
            "embeddedLinks": 1234
        ])
        
        XCTAssertTrue(object.embeddedLinks == nil)
    }
    
    /// embeddedLinks is empty, no links.
    func testInit_withEmptyEmbeddedLinksDictionary_noLinksAdded() {
        let object = EmbeddedLinksListItem(dictionary: [
            "embeddedLinks": [:]
        ])
        
        XCTAssertTrue(object.embeddedLinks == nil)
    }
    
    /// embeddedLinks contains one object, one link created with correct data.
    func testInit_withOneLinkInDictionary_oneLinkAdded() {
        let object = EmbeddedLinksListItem(dictionary: EmbeddedLinksListItemTests.dictionary)
        
        XCTAssertTrue(object.embeddedLinks?.count == 1)
        XCTAssertTrue(object.embeddedLinks?.first?.destination == "http://www.google.com")
        XCTAssertTrue(object.embeddedLinks?.first?.linkClass == .external)
    }
    
    /// embeddedLinks contains two objects, two links created with correct data.
    func testInit_withTwoLinksInDictionary_twoLinksAdded() {
        var dictionary = EmbeddedLinksListItemTests.dictionary
        guard var embeddedLinks = dictionary["embeddedLinks"] as? [StormData] else {
            XCTFail("Coudln't find embeddedLinks")
            return
        }
        
        embeddedLinks.append(EmbeddedLinksListItemTests.link)

        dictionary["embeddedLinks"] = embeddedLinks
        
        let object = EmbeddedLinksListItem(dictionary: dictionary)
        
        XCTAssertTrue(object.embeddedLinks?.count == 2)
    }
    
    func testCellClass_returnsCorrectClass() {
        let item = EmbeddedLinksListItem(dictionary: [:])
        
        XCTAssertTrue(item.cellClass == EmbeddedLinksListItemCell.self)
    }
}
