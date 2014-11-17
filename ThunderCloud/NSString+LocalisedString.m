//
//  NSString+LocalisedString.m
//  ThunderCloud
//
//  Created by Matthew Cheetham on 16/09/2014.
//  Copyright (c) 2014 threesidedcube. All rights reserved.
//

#import "NSString+LocalisedString.h"
#import <objc/runtime.h>
#import "TSCStormLanguageController.h"
#import "TSCLocalisationController.h"
#import "NSObject+AddedProperties.h"

@import ThunderBasics;

@interface NSString (LocalisedStringPrivate)

@property (nonatomic, copy) NSString *localisationKey;

@end

NSString * const kLocalisationKeyPropertyKey = @"kLocalisationKey";

@implementation NSString (LocalisedString)

+ (instancetype)stringWithLocalisationKey:(NSString *)key
{
    NSString *currentLanguage = [[TSCStormLanguageController sharedController] currentLanguageShortKey];
    NSString *string = nil;
    
    if ([[TSCLocalisationController sharedController] localisationDictionaryForKey:key]) {
        
        NSDictionary *localisationDictionary = [[TSCLocalisationController sharedController] localisationDictionaryForKey:key];
        string = [NSString stringWithFormat:@"%@",localisationDictionary[currentLanguage]]; // There is a reason this is happening. It fixes a bug where these strings can't be higlighted for editing.
    } else {
        if ([[TSCStormLanguageController sharedController] stringForKey:key]) {
            string = [[TSCStormLanguageController sharedController] stringForKey:key];
        } else {
            string = key;
        }
    }
    
    string.localisationKey = key;
    return string;
}

+ (instancetype)stringWithLocalisationKey:(NSString *)key fallbackString:(NSString *)fallback
{
    NSString *currentLanguage = [[TSCStormLanguageController sharedController] currentLanguageShortKey];
    NSString *string = nil;
    
    if ([[TSCLocalisationController sharedController] localisationDictionaryForKey:key]) {
        
        NSDictionary *localisationDictionary = [[TSCLocalisationController sharedController] localisationDictionaryForKey:key];
        string = [NSString stringWithFormat:@"%@",localisationDictionary[currentLanguage]]; // There is a reason this is happening. It fixes a bug where these strings can't be higlighted for editing.
    } else {
        if ([[TSCStormLanguageController sharedController] stringForKey:key]) {
            string = [[TSCStormLanguageController sharedController] stringForKey:key];
        } else {
            string = fallback;
        }
    }
    
    string.localisationKey = key;
    return string;}

#pragma mark - setters/getters

- (NSString *)localisationKey
{
    return [self associativeObjectForKey:@"localisationKey"];
}

- (void)setLocalisationKey:(NSString *)localisationKey
{
    [self setAssociativeObject:localisationKey forKey:@"localisationKey"];
}

@end
