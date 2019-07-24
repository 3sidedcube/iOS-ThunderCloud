//
//  ImageRepresentationTests.swift
//  ThunderCloudTests
//
//  Created by Ryan Bourne on 06/03/2018.
//  Copyright © 2018 threesidedcube. All rights reserved.
//

@testable import ThunderCloud
import XCTest

class ImageRepresentationTests: XCTestCase {
    
    /// TODO: Ensure this is the right format...
    static let imageDictionary: StormData = [
        "class": "Image",
        "src": [
            "class": "InternalLink",
            "destination": "cache://content/1373021293_tabbaritem_emergency_x0.75.png"
        ],
        "dimensions": [
            "width": 1.0 as CGFloat,
            "height": 1.0 as CGFloat
        ],
        "mime": "image/png",
        "size": 1024,
        "locale": "eng",
    ]
    
    /*
     "image": {
     "class": "Image",
     "src": {
     "class": "ImageDescriptor",
     "x0.75": "cache://content/1373021293_tabbaritem_emergency_x0.75.png",
     "x1": "cache://content/1373021293_tabbaritem_emergency_x1.png",
     "x1.5": "cache://content/1373021293_tabbaritem_emergency_x1.5.png",
     "x2": "cache://content/1373021293_tabbaritem_emergency_x2.png"
     }
     }
     */
    
    /*
     init test cases:
     also always set mimetype, bytesize, locale to type-check it!
     */
    
    /// empty dictionary, return nil.
    func testInit_emptyDictionary_returnNil() {
        let image = ImageRepresentation(dictionary: [:])
        
        XCTAssertTrue(image == nil)
    }
    
    /// no src dictionary, return nil.
    func testInit_noSrcDictionary_returnNil() {
        var dictionary = ImageRepresentationTests.imageDictionary
        dictionary["src"] = NSNull()
        
        let image = ImageRepresentation(dictionary: dictionary)
        
        XCTAssertTrue(image == nil)
    }
    
    /// src dictionary in bad format, return nil.
    func testInit_srcDictionaryInvalid_returnNil() {
        var dictionary = ImageRepresentationTests.imageDictionary
        dictionary["src"] = "invalid format"
        
        let image = ImageRepresentation(dictionary: dictionary)
        
        XCTAssertTrue(image == nil)
    }
    
    /// src dictionary doesn't create stormlink object, return nil.
    func testInit_srcDictionaryDoesNotCreateStormLink_returnNil() {
        var dictionary = ImageRepresentationTests.imageDictionary
        dictionary["src"] = [
            "class": "ImageDescriptor"
        ]
        
        let image = ImageRepresentation(dictionary: dictionary)
        
        XCTAssertTrue(image == nil)
    }
    
    /// src dictionary in valid format, no dimensions, return object.
    func testInit_validDictionary_noDimensions_returnObject() {
        var dictionary = ImageRepresentationTests.imageDictionary
        dictionary["dimensions"] = NSNull()
        
        let image = ImageRepresentation(dictionary: dictionary)
        
        XCTAssertTrue(image != nil)
        XCTAssertTrue(image?.source != nil)
        XCTAssertTrue(image?.dimensions == .zero)
        XCTAssertTrue(image?.mimeType == "image/png")
        XCTAssertTrue(image?.byteSize == 1024)
        XCTAssertTrue(image?.locale == "eng")
    }
    
    /// src dictionary in valid format, has dimensions in bad format, return object with zero dimensions.
    func testInit_validDictionary_dimensionsInvalid_returnObject() {
        var dictionary = ImageRepresentationTests.imageDictionary
        dictionary["dimensions"] = [
            "width": "invalid",
            "height": true
        ]
        
        let image = ImageRepresentation(dictionary: dictionary)
        
        XCTAssertTrue(image != nil)
        XCTAssertTrue(image?.source != nil)
        XCTAssertTrue(image?.dimensions == .zero)
        XCTAssertTrue(image?.mimeType == "image/png")
        XCTAssertTrue(image?.byteSize == 1024)
        XCTAssertTrue(image?.locale == "eng")
    }
    
    /// src dictionary in valid format, has dimensions with wrong tags, return object with zero dimensions.
    func testInit_validDictionary_dimensionsWithWrongTags_returnObject() {
        var dictionary = ImageRepresentationTests.imageDictionary
        dictionary["dimensions"] = [
            "w": 1.0 as CGFloat,
            "h": 1.0 as CGFloat
        ]
        
        let image = ImageRepresentation(dictionary: dictionary)
        
        XCTAssertTrue(image != nil)
        XCTAssertTrue(image?.source != nil)
        XCTAssertTrue(image?.dimensions == CGSize(width: 0, height: 0))
        XCTAssertTrue(image?.mimeType == "image/png")
        XCTAssertTrue(image?.byteSize == 1024)
        XCTAssertTrue(image?.locale == "eng")
    }
    
    /// src dictionary in valid format, has valid dimensions, return object
    func testInit_validDictionary_dimensionsValid_returnObject() {
        let image = ImageRepresentation(dictionary: ImageRepresentationTests.imageDictionary)
        
        XCTAssertTrue(image != nil)
        XCTAssertTrue(image?.source != nil)
        XCTAssertTrue(image?.dimensions == CGSize(width: 1.0, height: 1.0))
        XCTAssertTrue(image?.mimeType == "image/png")
        XCTAssertTrue(image?.byteSize == 1024)
        XCTAssertTrue(image?.locale == "eng")
    }
    
}
