//
//  TSCSpotlightView.m
//  ThunderStorm
//
//  Created by Simon Mitchell on 11/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCSpotlightImageListItem.h"
#import "TSCSpotlightImageListItemViewItem.h"
#import "TSCSpotlightImageListItemViewCell.h"
#import "UINavigationController+TSCNavigationController.h"
#import "TSCLink.h"

@interface TSCSpotlightImageListItem () <TSCSpotlightImageListItemViewCellDelegate>

@end

@implementation TSCSpotlightImageListItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary parentObject:(id)parentObject
{
    if (self = [super initWithDictionary:dictionary parentObject:parentObject]) {
                
        self.items = [NSMutableArray array];
        
        for (NSDictionary *spotlightDictionary in dictionary[@"images"]) {
            
            TSCSpotlightImageListItemViewItem *item = [[TSCSpotlightImageListItemViewItem alloc] initWithDictionary:spotlightDictionary parentObject:self];
            [self.items addObject:item];
        }
    }
    
    return self;
}

- (TSCSpotlightImageListItemViewCell *)tableViewCell:(TSCSpotlightImageListItemViewCell *)cell
{
    cell.items = self.items;
    cell.delegate = self;
    self.parentNavigationController = cell.parentViewController.navigationController;
    
    return cell;
}

- (Class)tableViewCellClass
{
    return [TSCSpotlightImageListItemViewCell class];
}

- (SEL)rowSelectionSelector
{
    return NSSelectorFromString(@"handleSelection:");
}

- (id)rowSelectionTarget
{
    return self.parentObject;
}

- (TSCLink *)rowLink
{
    return self.link;
}

- (CGFloat)tableViewCellHeightConstrainedToSize:(CGSize)contrainedSize
{
    if (contrainedSize.width == 768) {
        return 380;
    } else if (contrainedSize.width >= 690) {
        return 380;
    }
    return 160;
}

- (BOOL)shouldDisplaySelectionIndicator
{
    return NO;
}

- (BOOL)shouldDisplaySelectionCell
{
    return NO;
}

#pragma mark - TSCSpotlightImageListItemViewCellDelegate methods

- (void)spotlightViewCell:(TSCSpotlightImageListItemViewCell *)cell didReceiveTapOnItemAtIndex:(NSInteger)index
{
    if (self.items.count == 0) { // If an animated image cell has no images this fixes a crash
        return;
    }
    
    TSCSpotlightImageListItemViewItem *item = [self.items objectAtIndex:index];
    
    if (item.link) {
        self.link = item.link;
        [self.parentNavigationController pushLink:self.link];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TSCStatEventNotification" object:self userInfo:@{@"type":@"Event", @"category":@"Spotlight", @"action":item.link.url.absoluteString}];
    }
    

}

@end