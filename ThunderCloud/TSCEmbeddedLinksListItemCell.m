//
//  TSCTableButtonViewCell.m
//  ThunderStorm
//
//  Created by Phillip Caudell on 04/12/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCEmbeddedLinksListItemCell.h"
#import "TSCInlineButtonView.h"
#import "TSCEmbeddedLinksListItem.h"
#import "UINavigationController+TSCNavigationController.h"
#import "TSCLink.h"

@interface TSCEmbeddedLinksListItemCell ()


@end

@implementation TSCEmbeddedLinksListItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
            self.preservesSuperviewLayoutMargins = NO;
        }
        
        self.shouldDisplaySeparators = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.links.count > 0) {
        float textLabelWidth = self.bounds.size.width - 30;
        float detailTextLabelWidth = self.bounds.size.width - 30;
        
        if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            textLabelWidth = self.bounds.size.width - self.imageView.frame.size.width - 60;
            detailTextLabelWidth = self.bounds.size.width - self.imageView.frame.size.width - 60;
        }
        
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 12, textLabelWidth, self.textLabel.frame.size.height);
        
        float detailTextLabelY = 12;
        
        if (self.textLabel.text.length > 0) {
            detailTextLabelY = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 4;
        }
        
        self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, detailTextLabelY, detailTextLabelWidth, self.detailTextLabel.frame.size.height);
        self.textLabel.textAlignment = self.detailTextLabel.textAlignment = [TSCThemeManager localisedTextDirectionForBaseDirection:NSTextAlignmentLeft];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self layoutLinks];
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
        self.preservesSuperviewLayoutMargins = NO;
    }
    
    self.shouldDisplaySeparators = YES;
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (void)setLinks:(NSArray *)links
{
    _links = links;
}

-(void)layoutLinks {
    
    float buttonY = 12;
    
    float buttonOffset = 15;
    
    //Remove all previous buttons:
    
    for (UIView *subView in self.contentView.subviews) {
        
        if ([subView isKindOfClass:[TSCInlineButtonView class]]) {
            
            [subView removeFromSuperview];
        }
    }
    
    if (self.textLabel.text.length > 0) {
        buttonY = MAX(buttonY, self.textLabel.frame.origin.y + self.textLabel.frame.size.height + buttonOffset);
    }
    
    if (self.detailTextLabel.text.length > 0) {
        buttonY = MAX(buttonY, self.detailTextLabel.frame.origin.y + self.detailTextLabel.frame.size.height + buttonOffset);
    }
    
    for (TSCLink *link in self.links) {
        
        TSCInlineButtonView *button = [[TSCInlineButtonView alloc] init];
        button.link = link;
        [button setTitle:link.title forState:UIControlStateNormal];
        [button setTitleColor:[[TSCThemeManager sharedTheme] mainColor] forState:UIControlStateNormal];
        button.layer.backgroundColor = [UIColor whiteColor].CGColor;
        button.layer.borderColor = [[TSCThemeManager sharedTheme] mainColor].CGColor;
        button.layer.borderWidth = 1.0f;
        
        [button addTarget:self action:@selector(handleEmbeddedLink:) forControlEvents:UIControlEventTouchUpInside];
        
        float x = self.textLabel.frame.origin.x;
        
        if (self.detailTextLabel.frame.origin.x > self.textLabel.frame.origin.x && self.detailTextLabel.text.length > 0) {
            x = self.detailTextLabel.frame.origin.x;
        }
        
        if (x == 0) {
            x = 15;
        }
        
        float width = self.contentView.frame.size.width;
        
        if (isPad()) {
            width = width - 70;
        }
        
        button.frame = CGRectMake(x, buttonY, width - 15 - x, 46);
        buttonY = buttonY + 60;
        
        [self.contentView addSubview:button];
    }
}

- (void)handleEmbeddedLink:(TSCInlineButtonView *)sender
{
    [self.parentViewController.navigationController pushLink:sender.link];
}


@end
