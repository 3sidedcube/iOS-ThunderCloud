//
//  TSCVideoListItemView.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 27/09/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCVideoListItemView.h"
#import "TSCAnnularPlayButton.h"
#import "TSCVideoListItemViewCell.h"
#import "TSCLink.h"
#import "TSCLink+Youtube.h"

@import YouTubeiOSPlayerHelper;

@interface TSCVideoListItemView ()

    @property (nonatomic, strong) YTPlayerView *playerView;

@end


@implementation TSCVideoListItemView

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        
        self.duration = [dictionary[@"duration"] floatValue] / 1000;
        [self.link.attributes addObjectsFromArray:dictionary[@"attributes"]];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary parentObject:(id)parentObject
{
    if (self = [super initWithDictionary:dictionary parentObject:parentObject]) {
        self.duration = [dictionary[@"duration"] floatValue] / 1000;
        [self.link.attributes addObjectsFromArray:dictionary[@"attributes"]];
    }
    
    return self;
}

- (BOOL)shouldDisplaySelectionCell
{
    return NO;
}

- (BOOL)shouldDisplaySelectionIndicator
{
    return NO;
}

- (id)rowSelectionTarget
{
    return self;
}

- (SEL)rowSelectionSelector {
    return @selector(handleSelection:);
}

- (void)handleSelection:(TSCTableSelection *)selection
{
    TSCLink *url = [selection.object rowLink];
    
    if (url && [url isKindOfClass:[TSCLink class]]) {
        NSString *youtubeVideoId = [url youtubeVideoId];
        
        if (youtubeVideoId) {
            [self.playerView loadWithVideoId:youtubeVideoId playerVars:@{@"playsinline":@1, @"rel": @0}];
            
        } else {
            [self.playerView.webView removeFromSuperview];
        }
    }
}

- (Class)tableViewCellClass;
{
    return [TSCVideoListItemViewCell class];
}

- (TSCVideoListItemViewCell *)tableViewCell:(TSCVideoListItemViewCell *)cell
{
    cell = (TSCVideoListItemViewCell *)[super tableViewCell:cell];
    cell.duration = self.duration;
    
    self.playerView = cell.playerView;

    return cell;
}

@end
