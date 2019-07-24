//
//  TSCLinkTests.swift
//  ThunderCloud
//
//  Created by Joel Trew on 18/09/2017.
//  Copyright © 2017 threesidedcube. All rights reserved.
//

import XCTest
import ThunderCloud

class StormLinkTests: XCTestCase {
    
    var stormLanguageController: StormLanguageController? = nil
    
    static let linkDictionary: [AnyHashable: Any] = [
        "class": "LocalisedLink",
        "title": [
            "class": "Text",
            "content": [
                "en": "Hello",
                "fra": "Bonjour"
            ]
        ],
        "type": "UriLink",
        "links": [
            [
                "class": "LocalisedLinkDetail",
                "src": "https://www.google.fr",
                "locale": "fra"
            ],
            [
                "class": "LocalisedLinkDetail",
                "src": "https://www.google.co.uk",
                "locale": "eng"
            ],
            [
                "class": "LocalisedLinkDetail",
                "src": "https://www.google.br",
                "locale": "bra_eng"
            ]
        ]
    ]
    
    func testInitialisation() {
        
        StormLanguageController.shared.currentLanguage = "eng"
        
        let link = StormLink(dictionary: StormLinkTests.linkDictionary)
        
        XCTAssertNotNil(link, "Link initialised from localisedLink returned nil")
        if let link = link {
            
            XCTAssertNotNil(link.url)
            if let url = link.url {
                XCTAssertEqual(url.absoluteString, "https://www.google.co.uk")
            }
        }
    }
    
    func test_titleInWrongFormat_titleIsNil() {
        var dictionary = StormLinkTests.linkDictionary
        dictionary["title"] = 1
        
        let link = StormLink(dictionary: dictionary)
        
        XCTAssertNotNil(link)
        XCTAssertTrue(link?.title == nil)
    }
    
    func test_classIsInvalid_returnsNil() {
        var dictionary = StormLinkTests.linkDictionary
        dictionary["class"] = 123
        
        let link = StormLink(dictionary: dictionary)
        
        XCTAssertTrue(link == nil)
    }
    
    func testLocalisedFrench() {
        
        StormLanguageController.shared.currentLanguage = "fra"
        
        let link = StormLink(dictionary: StormLinkTests.linkDictionary)
        
        XCTAssertNotNil(link, "Link initialised from localisedLink returned nil")
        if let link = link {
            
            XCTAssertNotNil(link.url)
            if let url = link.url {
                XCTAssertEqual(url.absoluteString, "https://www.google.fr")
            }
        }
    }
    
    func testPicksCorrectLanguageAndRegion() {
        
        StormLanguageController.shared.currentLanguage = "bra_eng"
        
        let link = StormLink(dictionary: StormLinkTests.linkDictionary)
        
        XCTAssertNotNil(link, "Link initialised from localisedLink returned nil")
        if let link = link {
            
            XCTAssertNotNil(link.url)
            if let url = link.url {
                XCTAssertEqual(url.absoluteString, "https://www.google.br")
            }
        }
    }
    
    // Tests falling back to main language, i.e usa_eng should fall back to eng and not bra_eng
    func testFallbackToMainLanguage() {
        
        StormLanguageController.shared.currentLanguage = "usa_eng"
        
        let link = StormLink(dictionary: StormLinkTests.linkDictionary)
        
        XCTAssertNotNil(link, "Link initialised from localisedLink returned nil")
        if let link = link {
            
            XCTAssertNotNil(link.url)
            if let url = link.url {
                XCTAssertEqual(url.absoluteString, "https://www.google.co.uk")
            }
        }
    }
    
    func testFallbackToMainToFirstLanguage() {
        
        StormLanguageController.shared.currentLanguage = "usa_kor"
        
        let link = StormLink(dictionary: StormLinkTests.linkDictionary)
        
        XCTAssertNotNil(link, "Link initialised from localisedLink returned nil")
        if let link = link {
            
            XCTAssertNotNil(link.url)
            if let url = link.url {
                XCTAssertEqual(url.absoluteString, "https://www.google.fr")
            }
        }
    }
    
    /// URL has no scheme, only defaults are set.
    func testInitWithURL_noScheme_onlyDefaultsSet() {
        let link = StormLink(url: URL(string: "google.com")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .url, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has cache scheme but no host, only defaults are set.
    func testInitWithURL_noHost_onlyDefaultsSet() {
        let link = StormLink(url: URL(string: "/1234")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .url, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has scheme cache, set as internal.
    func testInitWithURL_cacheScheme_jsonExtension_pagesHost_setAsInternal() {
        let link = StormLink(url: URL(string: "cache://pages/1234.json")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .internal, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has scheme cache, but a non handled host - set as .url.
    func testInitWithURL_cacheScheme_setAsInternal() {
        let link = StormLink(url: URL(string: "cache://google/1234.json")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .url, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has scheme cache, native host - set as .native.
    func testInitWithURL_cacheScheme_nativeHost_setAsNative() {
        let link = StormLink(url: URL(string: "cache://native/1234.json")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .native, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has scheme mailto with no host, set as email.
    func testInitWithURL_mailtoScheme_setAsEmail() {
        let link = StormLink(url: URL(string: "mailto://email@email.com")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .email, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has scheme sms, set as sms.
    func testInitWithURL_smsScheme_setAsSMS() {
        let link = StormLink(url: URL(string: "sms://01234567890")!)
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .sms, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has scheme tel, set as call.
    func testInitWithURL_telScheme_setAsCall() {
        let link = StormLink(url: URL(string: "tel://01234567890")!)
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .call, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    /// URL has unhandled scheme, link class remains URL.
    func testInitWithURL_unhandledScheme_setAsURL() {
        let link = StormLink(url: URL(string: "unknown://native/1234.json")!)
        
        XCTAssertNotNil(link)
        expectStormLink(link: link, toMatch: .url, title: "Link", body: nil, recipients: nil, destination: nil, duration: nil)
    }
    
    func expectStormLink(link: StormLink, toMatch linkClass: StormLink.LinkClass, title: String?, body: String?, recipients: [String]?, destination: String?, duration: TimeInterval?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(link.linkClass == linkClass, file: file, line: line)
        XCTAssertTrue(link.title == title, file: file, line: line)
        XCTAssertTrue(link.body == body, file: file, line: line)
        //XCTAssertTrue(link.recipients == recipients, file: file, line: line)
        XCTAssertTrue(link.destination == destination, file: file, line: line)
        XCTAssertTrue(link.duration == duration, file: file, line: line)
    }
    
    func testStormLinkInit_setsAllPropertiesToDefaultValues() {
        let link = StormLink()
        XCTAssertTrue(link.title == "Link")
        XCTAssertTrue(link.url == nil)
        XCTAssertTrue(link.linkClass == .internal)
        XCTAssertTrue(link.body == nil)
        XCTAssertTrue(link.recipients == nil)
        XCTAssertTrue(link.destination == nil)
        XCTAssertTrue(link.duration == nil)
    }
    
}
