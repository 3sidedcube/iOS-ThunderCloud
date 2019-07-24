//
//  AppIdentityTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 07/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class AppIdentityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        StormLanguageController.shared.currentLanguage = "eng"
    }
    
    static let dictionary: StormData = [
        "appIdentifier": "ARC_STORM-1-1",
        "android": [
            "packageName": "com.cube.arc.fa"
        ],
        "ios": [
            "launcher": "ARCFA://",
            "iTunesId": "529160691",
            "countryCode": "us"
        ],
        "web": [
            "url": "http://www.redcross.org/mobile-apps/first-aid-app"
        ],
        "name": [
            "en": "First aid"
        ]
    ]
    
    /// empty dictionary, everything nil.
    func testInit_withEmptyDictionary_everythingNil() {
        let identity = AppIdentity(dictionary: [:])
        
        XCTAssertTrue(identity.identifier == nil)
        XCTAssertTrue(identity.iTunesId == nil)
        XCTAssertTrue(identity.countryCode == nil)
        XCTAssertTrue(identity.launchURL == nil)
        XCTAssertTrue(identity.name == nil)
    }
    
    /// dictionary with invalid ios object, all ios nil.
    func testInit_withInvalidiOSObject_allIOSObjectsNil() {
        var alteredIdentity = AppIdentityTests.dictionary
        alteredIdentity["ios"] = "app data"
        
        let identity = AppIdentity(dictionary: alteredIdentity)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == nil)
        XCTAssertTrue(identity.countryCode == nil)
        XCTAssertTrue(identity.launchURL == nil)
        XCTAssertTrue(identity.name == "First aid")
    }
    
    /// dictionary with invalid name object, name nil.
    func testInit_withInvalidNameObject_nameNil() {
        var alteredIdentity = AppIdentityTests.dictionary
        alteredIdentity["name"] = "app name"
        
        let identity = AppIdentity(dictionary: alteredIdentity)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == "529160691")
        XCTAssertTrue(identity.countryCode == "us")
        XCTAssertTrue(identity.launchURL == URL(string: "ARCFA://"))
        XCTAssertTrue(identity.name == nil)
    }
    
    /// dictionary with valid name but nil currentLanguageShortKey, name nil.
    func testInit_withValidNameButNoCurrentLanguageShortKey_nameNil() {
        StormLanguageController.shared.currentLanguage = nil
        var alteredIdentity = AppIdentityTests.dictionary
        
        let identity = AppIdentity(dictionary: alteredIdentity)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == "529160691")
        XCTAssertTrue(identity.countryCode == "us")
        XCTAssertTrue(identity.launchURL == URL(string: "ARCFA://"))
        XCTAssertTrue(identity.name == nil)
    }
    
    /// dictionary with valid name and currentLanguageShortKey, but name not found, name defaults to English.
    func testInit_withValidNameAndSpanishCurrentLanguageShortKey_nameNotFound_englishNameUsed() {
        StormLanguageController.shared.currentLanguage = "spa"
        var alteredIdentity = AppIdentityTests.dictionary
        
        let identity = AppIdentity(dictionary: alteredIdentity)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == "529160691")
        XCTAssertTrue(identity.countryCode == "us")
        XCTAssertTrue(identity.launchURL == URL(string: "ARCFA://"))
        XCTAssertTrue(identity.name == "First aid")
    }
    
    /// dictionary with valid name and currentLanguageShortKey, but name not found inc english, name is nil.
    func testInit_withValidNameAndSpanishCurrentLanguageShortKey_noNameFound_nameNil() {
        StormLanguageController.shared.currentLanguage = "spa"
        var alteredIdentity = AppIdentityTests.dictionary
        alteredIdentity["name"] = NSNull()
        
        let identity = AppIdentity(dictionary: alteredIdentity)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == "529160691")
        XCTAssertTrue(identity.countryCode == "us")
        XCTAssertTrue(identity.launchURL == URL(string: "ARCFA://"))
        XCTAssertTrue(identity.name == nil)
    }
    
    /// dictionary with valid ios object, but launch url invalid, launch url is nil.
    func testInit_withValidIosObject_invalidLaunchURL_launchURLIsNil() {
        var alteredIdentity = AppIdentityTests.dictionary
        var iOSObject = alteredIdentity["ios"] as? StormData
        iOSObject?["launcher"] = 123
        alteredIdentity["ios"] = iOSObject
        
        let identity = AppIdentity(dictionary: alteredIdentity)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == "529160691")
        XCTAssertTrue(identity.countryCode == "us")
        XCTAssertTrue(identity.launchURL == nil)
        XCTAssertTrue(identity.name == "First aid")
    }
    
    /// dictionary with all valid obejcts, all is correct.
    func testInit_withValidObjects_allIsSet() {
        let identity = AppIdentity(dictionary: AppIdentityTests.dictionary)
        
        XCTAssertTrue(identity.identifier == "ARC_STORM-1-1")
        XCTAssertTrue(identity.iTunesId == "529160691")
        XCTAssertTrue(identity.countryCode == "us")
        XCTAssertTrue(identity.launchURL == URL(string: "ARCFA://"))
        XCTAssertTrue(identity.name == "First aid")
    }
    
}
