//
//  GuideView.m
//  mall
//
//  Created by megvii on 14-9-27.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import "GuideView.h"
#import "AppDelegate.h"

@implementation GuideView

+ (void)statr
{
    BOOL firstrun = [GuideView checkFirstRun];
    if (firstrun == YES) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window setBackgroundColor:[UIColor whiteColor]];
        [window addSubview:guideView];
        [window setWindowLevel:UIWindowLevelNormal];
    }
}

//检测 当前版本 是否首次运行
+ (BOOL)checkFirstRun
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    BOOL firstrun = [[NSUserDefaults standardUserDefaults] boolForKey:app_Version];
    if (firstrun == NO) {
        firstrun = YES;
        [[NSUserDefaults standardUserDefaults] setBool:firstrun forKey:app_Version];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor ytColorWithRed:26 green:196 blue:178 alpha:1]];
        
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self.mainScrollView setBounces:NO];
        [self.mainScrollView setPagingEnabled:YES];
        [self.mainScrollView setShowsHorizontalScrollIndicator:NO];
        [self.mainScrollView setShowsVerticalScrollIndicator:NO];
        [self.mainScrollView setDelegate:self];
        
        [self addSubview:self.mainScrollView];
        [self creatView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.center.x - 50, WIN_HEIGHT - 30, 100, 30)];
        self.pageControl.numberOfPages = 3;
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)creatView
{
    NSString *imageName = @"guidda_4_";
    
    CGRect rect = self.frame;
    for (int i = 1; i <= 3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.mainScrollView addSubview:imageView];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d", imageName, i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [imageView setImage:image];
   
        rect = CGRectOffset(rect, WIN_WIDTH, 0);
        
        if (i == 3) {
            [imageView setUserInteractionEnabled:YES];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake((WIN_WIDTH - 150) / 2, WIN_HEIGHT * 0.86 , 150, 40)];
            
            [imageView addSubview:button];
//            button.autoresizingMask = UIViewAutoresizingFlexibleHeight;

            [button setBackgroundImage:[UIImage imageNamed:@"btn_guida_press"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_guida_seleted"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(finshAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    [self.mainScrollView setContentSize:CGSizeMake(WIN_WIDTH * 3, WIN_HEIGHT)];
}

- (void)finshAction:(UIButton *)sender
{
    [sender setSelected:YES];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                     }];
    
    if (self.finshBlcok) {
        self.finshBlcok(nil);
    }
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / WIN_WIDTH;
    self.pageControl.currentPage = page;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
