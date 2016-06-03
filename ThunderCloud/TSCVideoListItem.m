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

@interface TSCLink (YouTube)

- (NSString  * _Nullable)youtubeVideoId;

@end

@implementation TSCLink (YouTube)

- (NSString *)youtubeVideoId
{
    if (![self.linkClass isEqualToString:@"ExternalLink"] || !self.url.absoluteString || ![self.url.absoluteString containsString:@"youtube.com"]) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.url resolvingAgainstBaseURL:false];
    __block NSString *identifier;
    
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj.name isEqualToString:@"v"] && obj.value) {
            identifier = obj.value;
            *stop = true;
        }
    }];
    
    return identifier;
}

@end

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
    
    NSString *youtubeVideoId;
    
    for (TSCVideo *video in self.videos) {
        
        if ([video.videoLocale isEqual:[TSCStormLanguageController sharedController].currentLocale]) {
            youtubeVideoId = [video.videoLink youtubeVideoId];
        }
    }
    
    if (!youtubeVideoId && self.videos.firstObject) {
        youtubeVideoId = [((TSCVideo *)self.videos.firstObject).videoLink youtubeVideoId];
    }
    
    if (youtubeVideoId) {
        [cell.playerView loadWithVideoId:youtubeVideoId playerVars:@{@"playsinline":@1}];
        cell.playButton.hidden = true;
    } else {
        [cell.playerView.webView removeFromSuperview];
        cell.playButton.hidden = false;
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
