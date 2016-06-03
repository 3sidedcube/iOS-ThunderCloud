//
//  TSCMultiVideoListItemView.m
//  ThunderStorm
//
//  Created by Matt Cheetham on 16/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCVideoListItem.h"
#import "TSCVideo.h"
#import "TSCMultiVideoListItemViewCell.h"
#import "TSCAnnularPlayButton.h"
#import "UINavigationController+TSCNavigationController.h"
#import "TSCStormLanguageController.h"
#import "TSCLink.h"


@implementation TSCVideoListItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super initWithDictionary:dictionary]) {
        
        self.videos = [NSMutableArray array];
        
        for (NSDictionary *video in dictionary[@"videos"]) {
            TSCVideo *newVideo = [[TSCVideo alloc] initWithDictionary:video];
            [self.videos addObject:newVideo];
        }
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary parentObject:(id)parentObject
{
    if (self = [super initWithDictionary:dictionary parentObject:parentObject]) {
        
        self.videos = [NSMutableArray array];
        
        for (NSDictionary *video in dictionary[@"videos"]) {
            TSCVideo *newVideo = [[TSCVideo alloc] initWithDictionary:video];
            [self.videos addObject:newVideo];
        }
    }
    
    return self;
}

- (id)rowSelectionTarget
{
    return self;
}

- (SEL)rowSelectionSelector
{
    return @selector(playVideo);
}

- (TSCMultiVideoListItemViewCell *)tableViewCell:(TSCMultiVideoListItemViewCell *)cell
{
    self.parentNavigationController = cell.parentViewController.navigationController;
        
    cell.videos = self.videos;
    cell.video = nil;
    
    for (TSCVideo *video in self.videos) {
        
        if ([video.videoLocale isEqual:[TSCStormLanguageController sharedController].currentLocale]) {
            cell.video = video;
        }
    }
    
    if (!cell.video && self.videos.firstObject) {
        cell.video = self.videos.firstObject;
    }
    
    return cell;
}

- (Class)tableViewCellClass
{
    return [TSCMultiVideoListItemViewCell class];
}

#pragma mark - Play videos

- (void)playVideo
{
    [self.parentNavigationController pushVideos:self.videos];
}

@end
