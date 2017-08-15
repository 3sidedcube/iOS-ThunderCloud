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
#import "TSCVideoLanguageSelectionViewController.h"
#import "TSCVideo.h"
#import "TSCLink+Youtube.h"

@import UIKit;
@import ThunderBasics;

@interface TSCMultiVideoListItemViewCell () <TSCVideoLanguageSelectionViewControllerDelegate>

@end

@implementation TSCMultiVideoListItemViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.switchVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"mediaLanguageButton" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        [self.switchVideoButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.contentView addSubview:self.switchVideoButton];
        [self.switchVideoButton addTarget:self action:@selector(handleSwitchVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.switchVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"mediaLanguageButton" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        [self.switchVideoButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.contentView addSubview:self.switchVideoButton];
        [self.switchVideoButton addTarget:self action:@selector(handleSwitchVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.switchVideoButton sizeToFit];
    [self.switchVideoButton setX: self.bounds.size.width - self.switchVideoButton.frame.size.width - 12];
    [self.switchVideoButton setY:self.contentView.frame.size.height - self.switchVideoButton.frame.size.height - 12];
    [self.contentView bringSubviewToFront:self.switchVideoButton];
}


- (void)playerViewDidBecomeReady:(nonnull YTPlayerView *)playerView;
{
    self.playerView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        [self.contentView bringSubviewToFront:self.playerView];
        [self.contentView bringSubviewToFront:self.switchVideoButton];
        self.playerView.alpha = 1.0;
    }];
}

- (void)handleSwitchVideo
{
    TSCVideoLanguageSelectionViewController *selectedLanguageView = [[TSCVideoLanguageSelectionViewController alloc] initWithVideos:self.videos];
    selectedLanguageView.videoSelectionDelegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedLanguageView];
    [self.parentViewController presentViewController:navController animated:YES completion:nil];
}

- (void)videoLanguageSelectionViewController:(TSCVideoLanguageSelectionViewController *)view didSelectVideo:(TSCVideo *)video
{
    self.video = video;
}

- (void)setVideos:(NSArray<TSCVideo *> *)videos
{
    _videos = videos;
    if (videos.count <= 1) {
        self.switchVideoButton.hidden = true;
    } else {
        self.switchVideoButton.hidden = false;
    }
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
