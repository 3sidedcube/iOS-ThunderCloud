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

@implementation TSCVideoListItem

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        self.videos = [NSMutableArray array];
        
        for(NSDictionary *video in dictionary[@"videos"]){
            TSCVideo *newVideo = [[TSCVideo alloc] initWithDictionary:video];
            [self.videos addObject:newVideo];
        }
    }

    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary parentObject:(id)parentObject
{
    self = [super initWithDictionary:dictionary parentObject:parentObject];
    
    if (self) {
        self.videos = [NSMutableArray array];
        
        for(NSDictionary *video in dictionary[@"videos"]){
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
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
    
//    [cell.playButton addGestureRecognizer:tapGesture];
//    cell.playButton.userInteractionEnabled = YES;
    
    self.parentNavigationController = cell.parentViewController.navigationController;

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
