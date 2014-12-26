//
//  YTAlertTableView.m
//  ImhtDoctor
//
//  Created by imht-ios on 14-6-23.
//  Copyright (c) 2014年 imht. All rights reserved.
//

#import "YTAlertTableView.h"

#define TOPINDETLIMIT   50
#define LEFTLIMIT       50
#define TOPTITLEHIGHT   50
#define BOTTOMBTNHIGHT  50

@interface YTAlertTableView ()
{
    NSString *_title;
    NSString *_cancelTitle;
    UIView *_backGroundView;
    UIButton *_bottomBTN;
    UILabel *_titleLabel;
}


/**
 *  该界面消失
 */
- (void)dismissYTAlertView;



@end


@implementation YTAlertTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        NSException *exception = [NSException exceptionWithName:@"初始化错误!"
//                                                         reason:@"请使用规定的初始化方法"
//                                                       userInfo:nil];
//        [exception raise];
        
    }
    return self;
}

-(void)createBackgroundView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setText:_title];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setBackgroundColor:[UIColor ytColorWithRed:241 green:235 blue:230 alpha:1]];
        [self addSubview:_titleLabel];
        
        _bottomBTN = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_bottomBTN];
        [_bottomBTN setBackgroundColor:[UIColor ytColorWithRed:241 green:235 blue:230 alpha:1]];
        [_bottomBTN setTitle:_cancelTitle forState:UIControlStateNormal];
        [_bottomBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomBTN addTarget:self action:@selector(dismissYTAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomBTN drawLineWidth:1.0f color:[UIColor myGray] startPoint:CGPointMake(0, 1) endPoint:CGPointMake(WIN_WIDTH - 50 * 2, 1)];
        [_titleLabel drawLineWidth:1.0f color:[UIColor myGray] startPoint:CGPointMake(0, _titleLabel.bounds.size.height) endPoint:CGPointMake(WIN_WIDTH - 50 * 2, _titleLabel.bounds.size.height)];
        
        [_bottomBTN setAlpha:0.9];
        [_titleLabel setAlpha:0.9];
    }
}

- (void)animationIn
{
    if (self.superview == nil)
    {
        [self setFrame:[UIScreen mainScreen].bounds];
        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
        [mainWindow addSubview:self];
        
        [_tableView    setFrame:CGRectMake(LEFTLIMIT, TOPTITLEHIGHT + TOPINDETLIMIT, WIN_WIDTH - LEFTLIMIT * 2, WIN_HEIGHT - TOPINDETLIMIT * 2 - TOPTITLEHIGHT - BOTTOMBTNHIGHT)];
        [_bottomBTN    setFrame:CGRectMake(LEFTLIMIT, WIN_HEIGHT - BOTTOMBTNHIGHT - TOPINDETLIMIT, WIN_WIDTH - LEFTLIMIT * 2, BOTTOMBTNHIGHT)];
        [_titleLabel   setFrame:CGRectMake(LEFTLIMIT, TOPINDETLIMIT, WIN_WIDTH - LEFTLIMIT * 2, TOPTITLEHIGHT)];
    }
    
    [UIView animateWithDuration:0.2f
                     animations:^(){
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
                     }
                     completion:^(BOOL finsh){
                         
                     }];
}

- (void)dismissYTAlertView
{
    [UIView animateWithDuration:0.2f
                     animations:^(){
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
                         [_bottomBTN    setFrame:CGRectMake(self.center.x, self.center.y, 0, 0)];
                         [_titleLabel   setFrame:CGRectMake(self.center.x, self.center.y, 0, 0)];
                         [_tableView    setFrame:CGRectMake(self.center.x, self.center.y, 0, 0)];
                     }
                     completion:^(BOOL finsh){
                         
                         [UIView animateWithDuration:0.1f
                                          animations:^()
                          {
                              [self setFrame:CGRectMake(WIN_WIDTH / 2, WIN_HEIGHT / 2, 0, 0)];
                          }
                                          completion:^(BOOL finsh)
                          {
                              [self removeFromSuperview];
                          }];
                     }];
}

- (instancetype)initWithTitle:(NSString *)title
                    andCancel:(NSString *)canceltitle
                 andTableCell:(tableCellBlock)cell
                   andNumRows:(numberOfRowsInSectionBlock)numberOfRows
{
    self = [super init];
    if (self) {
        _title                  = title;
        _cancelTitle            = canceltitle;
        _YTTableCell            = cell;
        _YTTableRowsInSection   = numberOfRows;
    }
    
    BOOL test = [self testAllBlockDelegate];
    if (!test) {
        return nil;
    }
    [self createBackgroundView];

    return self;
}

- (BOOL)show
{
    BOOL test = [self testAllBlockDelegate];
    if (test) {
        [self animationIn];
    }

    return test;
}


-(BOOL)testAllBlockDelegate
{
    if (!_YTTableCell || !_YTTableRowsInSection) {
        [[NSException exceptionWithName:@"tableview代理设置不完全" reason:@"请正确设置tableview代理" userInfo:nil] raise];
        return NO;
    }
    return YES;
}


#pragma mark - uitableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.YTTableCell(tableView, indexPath);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.YTTableRowsInSection(tableView, section);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissYTAlertView];
    
    if (self.YTTableSelectAction) {
        self.YTTableSelectAction(tableView, indexPath);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
