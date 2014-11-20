//
//  TSCTextSelectionQuestionViewController.m
//  ThunderStorm
//
//  Created by Matt Cheetham on 11/11/2013.
//  Copyright (c) 2013 3 SIDED CUBE. All rights reserved.
//

#import "TSCTextQuizItem.h"
#import "TSCQuizItem.h"
#import "TSCQuizCompletionViewController.h"
#import "TSCQuizResponseTextOption.h"

@interface TSCTextQuizItem ()

@end

@implementation TSCTextQuizItem

- (id)initWithQuestion:(TSCQuizItem *)question
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.question = question;
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    TSCTableSection *questions = [TSCTableSection sectionWithTitle:nil footer:nil items:self.question.options target:self selector:@selector(handleResponse:)];
    
    self.dataSource = @[questions];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark Response handling

- (void)handleResponse:(TSCTableSelection *)selection
{
    if (self.question.selectedIndexes.count == self.question.limit && ![self.question.selectedIndexes containsObject:selection.indexPath]) {
        
        NSIndexPath *lastSelectedIndex = [self.question.selectedIndexes lastObject];
        TSCTableInputCheckViewCell *lastSelectedCell = (TSCTableInputCheckViewCell *)[self.tableView cellForRowAtIndexPath:lastSelectedIndex];
        [lastSelectedCell.checkView setOn:NO animated:YES];
        [self.question toggleSelectedIndex:lastSelectedIndex];
    }
    
    TSCTableInputCheckViewCell *cell = (TSCTableInputCheckViewCell *)[self.tableView cellForRowAtIndexPath:selection.indexPath];
    [cell.checkView setOn:!cell.checkView.isOn animated:YES];
    [self.tableView deselectRowAtIndexPath:selection.indexPath animated:YES];
    
    [self.question toggleSelectedIndex:selection.indexPath];
}

#pragma mark Header handling

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Constraints
    CGSize constraintForHeaderWidth = CGSizeMake(tableView.bounds.size.width - 20, MAXFLOAT);
    
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, constraintForHeaderWidth.width, 0)];
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, questionLabel.frame.size.height + 15, constraintForHeaderWidth.width, 0)];
    
    questionLabel.text = self.question.questionText;
    hintLabel.text = self.question.hintText;
    
    //Question Label
    questionLabel.numberOfLines = 0;
    questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    questionLabel.textAlignment = NSTextAlignmentCenter;
    questionLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    questionLabel.backgroundColor = [UIColor clearColor];
    
    //Hint Label
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.numberOfLines = 0;
    hintLabel.lineBreakMode = NSLineBreakByWordWrapping;
    hintLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    hintLabel.textColor = [[TSCThemeManager sharedTheme] secondaryLabelColor];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    
    //Calculated question size
    CGSize questionSize = [questionLabel sizeThatFits:constraintForHeaderWidth];
    CGSize hintSize = [hintLabel sizeThatFits:constraintForHeaderWidth];
    
    
    questionLabel.frame = CGRectMake(10, 10, constraintForHeaderWidth.width, questionSize.height);
    hintLabel.frame = CGRectMake(10, questionLabel.frame.size.height + 15, constraintForHeaderWidth.width, hintSize.height);
    
    //Create view to hold our labels
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, questionLabel.frame.size.height + hintLabel.frame.size.height)];
    questionView.backgroundColor = [UIColor colorWithRed:247.0f / 255.0f green:247.0f / 255.0f blue:247.0f / 255.0f alpha:1.0];
    
    //Add labels to header
    [questionView addSubview:questionLabel];
    [questionView addSubview:hintLabel];
    
    return questionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Constraints
    CGSize constraintForHeaderWidth = CGSizeMake(tableView.bounds.size.width - 20, MAXFLOAT);
    
    // Calculated question size
    CGRect questionRect = [self.question.questionText boundingRectWithSize:constraintForHeaderWidth options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]} context:nil];
    CGRect hintRect = [self.question.hintText boundingRectWithSize:constraintForHeaderWidth options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]} context:nil];
    
    return questionRect.size.height + hintRect.size.height + 20;
}

@end
