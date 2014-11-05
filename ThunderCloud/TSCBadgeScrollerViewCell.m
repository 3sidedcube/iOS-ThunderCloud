//
//  TSCBadgeScrollerViewCell.m
//  ThunderStorm
//
//  Created by Matt Cheetham on 27/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCBadgeScrollerViewCell.h"
#import "TSCBadgeScrollerItemViewCell.h"
#import "TSCBadge.h"
#import "TSCBadgeShareViewController.h"
#import "TSCImage.h"
#import "TSCBadgeController.h"
#import "TSCQuizPage.h"

@interface TSCBadgeScrollerFlowLayout : UICollectionViewFlowLayout

@end

@implementation TSCBadgeScrollerFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return CGPointMake(proposedContentOffset.x - 100, proposedContentOffset.y);
}

@end

@implementation TSCBadgeScrollerViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"TSCPortalViewCell-bg" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self.contentView addSubview:self.backgroundView];
        
        self.collectionViewLayout = [[TSCBadgeScrollerFlowLayout alloc] init];
        self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.collectionView];
        
        [self.collectionView registerClass:[TSCBadgeScrollerItemViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 16)];
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [[TSCThemeManager sharedTheme] mainColor];
        self.pageControl.currentPage = 0;
        self.pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
            self.preservesSuperviewLayoutMargins = NO;
        }
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentView.center = self.contentView.center;
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
}

#pragma mark Collection view datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.pageControl.numberOfPages = self.badges.count;
    return self.badges.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TSCBadge *badge = self.badges[indexPath.item];
    
    TSCBadgeScrollerItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.badgeImage.image = [TSCImage imageWithDictionary:badge.badgeIcon];
    cell.titleLabel.text = badge.badgeTitle;
    
    for (TSCQuizPage *quiz in self.quizzes) {
        if ([quiz.quizBadge.badgeId isEqualToString:badge.badgeId]) {
            cell.subtitleLabel.text = [NSString stringWithFormat:@"%lu question%@", (unsigned long)quiz.questions.count, quiz.questions.count == 1 ? @"" : @"s"];
            break;
        }
    }
    
    if ([[TSCBadgeController sharedController] hasEarntBadgeWithId:badge.badgeId]) {
        [cell setCompleted:YES];
    } else {
        [cell setCompleted:NO];
    }
    
    [cell layoutSubviews];
    
    return cell;
}

#pragma markk Collection view layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width, self.bounds.size.height + 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TSCBadge *badge = self.badges[indexPath.item];
    
    for (TSCQuizPage *quizPage in self.quizzes) {
        if (quizPage.quizBadge.badgeId == badge.badgeId) {
            if (isPad()) {
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:quizPage];
                navController.modalPresentationStyle = UIModalPresentationFormSheet;
                [self.parentViewController.navigationController presentViewController:navController animated:YES completion:nil];
            } else {
                quizPage.hidesBottomBarWhenPushed = YES;
                [self.parentViewController.navigationController pushViewController:quizPage animated:YES];
            }
            break;
        }
    }
}

#pragma mark - Refreshing

- (void)setBadges:(NSArray *)badges
{
    _badges = badges;
    [self.collectionView reloadData];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float page = ceilf(scrollView.contentOffset.x / self.bounds.size.width);
    
    self.currentPage = (int)page;
}

#pragma mark - Setter methods

- (void)setCurrentPage:(int)currentPage
{
    _currentPage = currentPage;
    
    self.pageControl.currentPage = currentPage;
}

@end
