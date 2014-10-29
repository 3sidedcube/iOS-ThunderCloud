//
//  TSCGroupView.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 27/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCList.h"
#import "TSCListPage.h"
@import ThunderBasics;

@implementation TSCList

- (id)initWithDictionary:(NSDictionary *)dictionary parentObject:(id)parentObject
{
    self = [super initWithDictionary:dictionary parentObject:parentObject];
    
    if (self) {
    
        self.header = TSCLanguageDictionary(dictionary[@"header"]);
        self.footer = TSCLanguageDictionary(dictionary[@"footer"]);
        
        NSMutableArray *items = [NSMutableArray array];
        
        for (NSDictionary *child in dictionary[@"children"]) {
                        
            id item = [TSCStormObject objectWithDictionary:child parentObject:self];
            
            if (item) {
                [items addObject:item];
            }
        }
    
        self.items = items;
    }
    
    return self;
}

- (void)handleSelection:(TSCTableSelection *)selection
{
    TSCListPage *listPage = (TSCListPage *)[self stormParentObject];
    [listPage handleSelection:selection];
}

#pragma mark Section data source

- (NSString *)sectionHeader
{
    return self.header;
}

- (NSString *)sectionFooter
{
    return self.footer;
}

- (NSArray *)sectionItems
{
    return self.items;
}

- (SEL)sectionSelector
{
    return nil;
}

- (id)sectionTarget
{
    return nil;
}


@end
