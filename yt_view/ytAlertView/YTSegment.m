//
//  YTSegment.m
//  ImhtDoctor
//
//  Created by imht-ios on 14-6-23.
//  Copyright (c) 2014年 imht. All rights reserved.
//

#import "YTSegment.h"


#define YTSegmentTagS 100


@interface YTSegment ()
{
    UIColor *_selectColor;
    UIColor *_normalColor;
    UIImage *_selectImage;
}

@end

@implementation YTSegment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _selectColor = [UIColor blueColor];
    _normalColor = [UIColor whiteColor];
    [self drawRoundBoderWidth:1.0f andColor:[UIColor blackColor] andRadius:8];
}

- (void)setTitleArray:(NSMutableArray *)titleArray
{
    if (_titleArray != titleArray) {
        _titleArray = titleArray;
        
        [self creatView];
    }
}

- (void)creatView
{
    if (_titleArray) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width / _titleArray.count, self.frame.size.height);

        for (int i = 0; i < _titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:rect];
            [button setTag:i + YTSegmentTagS];
            [button setTitle:[_titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [button setBackgroundColor:_normalColor];
            [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [self addSubview:button];
            rect = CGRectOffset(rect, self.frame.size.width / _titleArray.count, 0);
            if (i != 0) {
                [button drawLineWidth:1.0f color:[UIColor blackColor] startPoint:CGPointMake(0, 1) endPoint:CGPointMake(0, button.endY - 1)];
            }
        }
    }
}


- (void)action:(UIButton *)sender
{
    [self cancelAnySelect:sender];
    
    if (self.action) {
        self.action();
    }
}

- (void)cancelAnySelect:(UIButton *)button
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button1 = (UIButton *)view;
            if (button1 != button) {
                [button1 setBackgroundColor:_normalColor];
            }
            else
            {
                if (_selectImage) {
                    [button1 setBackgroundImage:_selectImage forState:UIControlStateNormal];
                }
                else
                {
                    [button1 setBackgroundColor:_selectColor];
                }
            }
        }
    }
}


- (void)setBackgroundImage:(UIImage *)image andIndex:(NSInteger )index
{
    UIButton *button = (UIButton *)[self viewWithTag:index + YTSegmentTagS];
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)settitleFont:(UIFont *)font
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button.titleLabel setFont:font];
        }
    }
}

- (void)setSelectColor:(UIColor *)color
{
    _selectColor = color;
}

- (void)setNormalColor:(UIColor *)color
{
    _normalColor = color;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button.titleLabel setBackgroundColor:color];
        }
    }
}

- (void)setselectImage:(UIImage *)image
{
    _selectImage = image;
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
