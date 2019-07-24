//
//  StandardListItemTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class StandardListItemTests: XCTestCase {
    
    static let dictionary: StormData = [
        "class": "StandardListItemView",
        "description": [
            "class": "Text",
            "content": "f34s9"
        ],
        "image": [
            "class": "Icon",
            "src": [
                "class": "ImageDescriptor",
                "x0.75": "",
                "x1": "",
                "x1.5": "",
                "x2": ""
            ]
        ],
        "link": [
            "class": "UriLink",
            "id": 6183530,
            "destination": "",
            "title": [
                "class": "Text",
                "content": "f34u4"
            ],
            "type": "ExternalLink"
        ],
        "title": [
            "class": "Text",
            "content": "f34s7"
        ]
    ]
    
    /// empty dictionary, nothing set, return .none
    func testAccessoryType_emptyDictionary_returnNone() {
        let item = StandardListItem(dictionary: [:])
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with no link, everything but link is set, return .none
    func testAccessoryType_dictionaryWithNoLink_returnNone() {
        var dictionary = StandardListItemTests.dictionary
        dictionary["link"] = NSNull()
        
        let item = StandardListItem(dictionary: dictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with link with empty url, return .none
    func testAccessoryType_dictionaryWithEmptyURLLink_returnNone() {
        let item = StandardListItem(dictionary: StandardListItemTests.dictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with link with non-empty url, return .disclosureIndicator
    func testAccessoryType_dictionaryWithNonEmptyURL_returnDisclosureIndicator() {
        var alteredDictionary = StandardListItemTests.dictionary
        var linkObject = alteredDictionary["link"] as? StormData
        linkObject?["destination"] = "https://google.co.uk"
        alteredDictionary["link"] = linkObject
        
        let item = StandardListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.accessoryType == .disclosureIndicator)
    }
    
    /// dictionary with link with nil url, link class is invalid, return .none
    func testAccessoryType_dictionaryWithNilURL_linkClassIsInvalid_returnNone() {
        var alteredDictionary = StandardListItemTests.dictionary
        var linkObject = alteredDictionary["link"] as? StormData
        linkObject?["destination"] = NSNull()
        alteredDictionary["link"] = linkObject
        
        let item = StandardListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with link with nil url, link class is sms, return .none.
    func testAccessoryType_dictionaryWithNilURL_linkClassIsSMS_returnDisclosureIndicator() {
        var alteredDictionary = StandardListItemTests.dictionary
        var linkObject = alteredDictionary["link"] as? StormData
        linkObject?["destination"] = NSNull()
        linkObject?["class"] = "SmsLink"
        alteredDictionary["link"] = linkObject
        
        let item = StandardListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with link with nil url, link class is emergency, return .none.
    func testAccessoryType_dictionaryWithNilURL_LinkClassIsEmergency_returnDisclosureIndicator() {
        var alteredDictionary = StandardListItemTests.dictionary
        var linkObject = alteredDictionary["link"] as? StormData
        linkObject?["destination"] = NSNull()
        linkObject?["class"] = "EmergencyLink"
        alteredDictionary["link"] = linkObject
        
        let item = StandardListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with link with nil url, link class is share, return .none.
    func testAccessoryType_dictionaryWithNilURL_linkClassIsShare_returnDisclosureIndicator() {
        var alteredDictionary = StandardListItemTests.dictionary
        var linkObject = alteredDictionary["link"] as? StormData
        linkObject?["destination"] = NSNull()
        linkObject?["class"] = "ShareLink"
        alteredDictionary["link"] = linkObject
        
        let item = StandardListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
    /// dictionary with link with nil url, link class is timer, return .none.
    func testAccessoryType_dictionaryWithNilURL_linkClassIsTimer_returnDisclosureIndicator() {
        var alteredDictionary = StandardListItemTests.dictionary
        var linkObject = alteredDictionary["link"] as? StormData
        linkObject?["destination"] = NSNull()
        linkObject?["class"] = "TimerLink"
        alteredDictionary["link"] = linkObject
        
        let item = StandardListItem(dictionary: alteredDictionary)
        
        XCTAssertTrue(item.accessoryType == .none)
    }
    
}
