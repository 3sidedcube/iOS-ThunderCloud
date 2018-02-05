//
//  TSCLocalisationKeyValue.h
//  ThunderCloud
//
//  Created by Matthew Cheetham on 16/09/2014.
//  Copyright (c) 2014 threesidedcube. All rights reserved.
//

@import Foundation;
@import ThunderTable;

@class TSCLocalisationLanguage;

/**
 An object representation of the value of a localised string for a particular language code
 */
@interface TSCLocalisationKeyValue : NSObject

/**
 @abstract The the language of this key
 */
@property (nonatomic, strong) TSCLocalisationLanguage *language;

/**
 @abstract The localised string for the assosicated language code
 */
@property (nonatomic, copy) NSString *localisedString;

/**
 @abstract The short code that represents the language in the CMS (E.g. "en")
 */
@property (nonatomic, copy) NSString *languageCode;

@end