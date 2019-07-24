//
//  VideoTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 07/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class VideoTests: XCTestCase {
    
    static let dictionary: StormData = [
        "class": "Video",
        "locale": "usa_en",
        "src": [
            "class": "InternalLink",
            "destination": "cache://content/1382017862526_app1seizure.mp4",
            "title": [
                "class": "Text",
                "content": "2g85v"
            ]
        ]
    ]
    
    /// empty dictionary, nothing set.
    func testInit_emptyDictionary_nothingSet() {
        
    }
    
    /// invalid src object types, link not set.
    func testInit_invalidSrcObject_linkNotSet() {
        
    }
    
    /// empty link src data, link not set.
    func testInit_emptySrcObject_linkNotSet() {
        
    }
    
    /// valid link src data, link set.
    func testInit_validData_allObjectsSet() {
        
    }
    
    /*
     locale test cases:
     */
    
    /// no localeString, returns nil.
    func testLocale_noLocaleString_returnNil() {
        
    }
    
    /// locale string is set, currentLocale is en, locale is correct.
    func testLocale_localeStringSet_returnLocale() {
        
    }
    
    /// no locale string, returns nil
    func testTitle_noLocaleString_returnNil() {
        
    }
    
    /// no language pack, returns nil
    func testTitle_noLanguagePack_returnNil() {
        
    }
    
    /// language pack available, returns correct language pack locale.
    func testTitle_localeStringAndLanguagePackAvailable_returnLocalisedLanguageName() {
        
    }
}
