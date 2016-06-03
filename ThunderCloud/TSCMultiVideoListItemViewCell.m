//
//  TSCMultiVideoListItemViewCell.m
//  ThunderStorm
//
//  Created by Matt Cheetham on 16/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCMultiVideoListItemViewCell.h"
#import "TSCLink.h"
#import "TSCAnnularPlayButton.h"

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

@implementation TSCMultiVideoListItemViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)setVideos:(NSArray<TSCVideo *> *)videos
{
    _videos = videos;
}

- (void)setVideo:(TSCVideo *)video
{
    if (video && _video != video) {
        
        NSString *youtubeVideoId = [video.videoLink youtubeVideoId];
        
        if (youtubeVideoId) {
            [self.playerView loadWithVideoId:youtubeVideoId playerVars:@{@"playsinline":@1}];
            self.playButton.hidden = true;
        } else {
            [self.playerView.webView removeFromSuperview];
            self.playButton.hidden = false;
        }
    }
    
    _video = video;
}
@end
