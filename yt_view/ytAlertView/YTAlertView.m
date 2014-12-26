//
//  YTAlertView.m
//  ImhtDoctor
//
//  Created by imht-ios on 14-7-3.
//  Copyright (c) 2014年 imht. All rights reserved.
//

#import "YTAlertView.h"

#define DEFAULTBGA 0.4f

#define YTWIN_WINDTH [UIScreen mainScreen].bounds.size.width
#define YTWIN_HIGHT [UIScreen mainScreen].bounds.size.height




@interface YTAlertView ()
{
//    CGRect _sViewFrame;
    BOOL _hasAnimation;
    CGRect _starSFrame;
    CGFloat _starAlpha;
}
@property (nonatomic, strong)  UITapGestureRecognizer *tapGest;


@end


@implementation YTAlertView


- (instancetype)initWithSourceView:(UIView *)sView
                      frameOfsView:(CGRect)sFrame
{
    self = [super init];
    if (self) {
        _sourceView = sView;
        self.sourceFrame = sFrame;
        _starAlpha = sView.alpha;
        
        [self setFrame:[UIScreen mainScreen].bounds];
        
        self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.0f];
        _backgroundColorAlpha = DEFAULTBGA;
        
        self.tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animationOut)];
        [self addGestureRecognizer:self.tapGest];
        
        _animationType = animation_fade;
        _flyDirection = fly_bottom;
        
    }
    
    return self;
}



- (void)animationIn
{
    [self creatView];
    
    if (_hasAnimation) {
        [UIView animateWithDuration:0.25f
                         animations:^(){
                             [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:_backgroundColorAlpha]];
                             [self finshAnimation];
                             [[self sourceView] setAlpha:_starAlpha];
                         }
                         completion:^(BOOL finsh){
                             
                         }];
    }
    else
    {
        [self finshAnimation];
    }
}

- (void)animationOut
{
    if (_hasAnimation) {
        [UIView animateWithDuration:0.25f
                         animations:^(){
                             [self startAnimation];
                             [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
                         }
                         completion:^(BOOL finsh){
                             [self.sourceView removeFromSuperview];
                             [self removeFromSuperview];
                         }];
    }
    else
    {
        [self startAnimation];
        [self.sourceView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)closeGes
{
    [self removeGestureRecognizer:self.tapGest];
}


//source的初始目标位置
- (void)startAnimation
{
    [self.sourceView setFrame:_starSFrame];
}

//source的结束位置
- (void)finshAnimation
{
    [self.sourceView setFrame:self.sourceFrame];
}

- (void)hideBottomView:(BOOL)hide
{
    if (YES == hide) {
        [self setFrame:self.sourceFrame];
        _backgroundColorAlpha = 0.0f;
    }
}


- (BOOL)showWithAnimation:(BOOL)animation
{
    if (![self checkSelf]) {
        return NO;
    }
    if (self.sourceView.superview == nil) {
        
        _hasAnimation = animation;
        CGRect rect = CGRectZero;
        
        rect = [self animationWithAniType:self.animationType
                               andFlyType:_flyDirection];
        [self.sourceView setFrame:rect];
        _starSFrame = rect;
        
        [self animationIn];
        
        return YES;
    }
    return NO;
}

//生成window界面
- (void)creatView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window setWindowLevel:UIWindowLevelNormal];
    
    [self addSubview:self.sourceView];
}

- (void)autoHideWithtime:(NSTimeInterval)time
{
    [self performSelector:@selector(hideWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:time];
}

- (BOOL)hideWithAnimation:(BOOL)animation
{
    [self animationOut];
    
    return YES;
}

//根据动画类型判断位置
- (CGRect)animationWithAniType:(animationType)aniType andFlyType:(animation_fly_direction)flyType
{
    CGRect rect = CGRectZero;

    if (aniType == animation_fade)
    {
        rect = self.sourceFrame;
        [self.sourceView setAlpha:0.0f];
    }
    else
    {
        switch (flyType) {
            case fly_top:
            {
                rect = CGRectMake(self.sourceFrame.origin.x, - self.sourceFrame.size.height, self.sourceFrame.size.width, self.sourceFrame.size.height);
            }
                break;
            case fly_bottom:
            {
                rect = CGRectMake(self.sourceFrame.origin.x, YTWIN_HIGHT, self.sourceFrame.size.width, self.sourceFrame.size.height);
            }
                break;
            case fly_left:
            {
                rect = CGRectMake(-self.sourceFrame.size.width, self.sourceFrame.origin.y, self.sourceFrame.size.width, self.sourceFrame.size.height);
            }
                break;
            case fly_right:
            {
                rect = CGRectMake(YTWIN_WINDTH, self.sourceFrame.origin.y, self.sourceFrame.size.width, self.sourceFrame.size.height);
            }
                break;
            default:
                break;
        }
    }
    
    return rect;
}



//检查设置
- (BOOL)checkSelf
{
    if (!self.sourceView) {
        [[NSException exceptionWithName:@"显示失败" reason:@"请检查是否设置   sourceview " userInfo:nil] raise];
        return NO;
    }
    
  return YES;
}

@end
