//
//  MMDProHUD.m
//  美美哒
//
//  Created by megvii on 14-8-5.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import "MMDProHUD.h"
#import "YTAlertView.h"

@interface MMDProHUD ()

@property (nonatomic, strong) YTAlertView *alertView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MMDProHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIN_WIDTH / 2 - 30, WIN_HEIGHT / 2, 60, 60)];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d", i]];
            [imageArray addObject:image];
        }
        
        [self.imageView setAnimationImages:imageArray];
        [self.imageView setAnimationRepeatCount:9999];
        [self.imageView setAnimationDuration:0.7f];
        
        self.alertView  = [[YTAlertView alloc] initWithSourceView:self.imageView
                                                     frameOfsView:self.imageView.frame];
        
        [self.alertView setAnimationType:animation_fade];
//        [self.alertView closeGes];
        [self.alertView setBackgroundColorAlpha:0];
    }
    return self;
}

+ (instancetype)HUDManager
{
    static MMDProHUD *HUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HUD = [[MMDProHUD alloc] init];
    });
    return HUD;
}

- (BOOL)starHUD
{
    [self.imageView startAnimating];
    [self.alertView showWithAnimation:YES];
    
    return YES;
}

- (BOOL)stopHUD
{
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.2f];
    
    return YES;
}

- (void)hideHUD
{
    [self.imageView stopAnimating];
    [self.alertView hideWithAnimation:YES];
}


@end
