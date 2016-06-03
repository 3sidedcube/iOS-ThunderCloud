//
//  TSCMultiVideoListItemViewCell.h
//  ThunderStorm
//
//  Created by Matt Cheetham on 16/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCVideoListItemViewCell.h"
@class TSCVideo;

/**
 The cell that represents a multi video item
 */
@interface TSCMultiVideoListItemViewCell : TSCVideoListItemViewCell

/**
 The array of videos that the list item is playing
 */
@property (nonatomic, strong) NSArray <TSCVideo *> * _Nullable videos;

/**
 The current video that is playing
 */
@property (nonatomic, strong) TSCVideo * _Nullable video;

/**
 The button which can be used to switch the video the cell is playing
 */
@property (nonatomic, strong) UIButton * _Nonnull switchVideoButton;

@end
