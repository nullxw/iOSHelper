//
//  UINavigationItem+ImhtNavi.m
//  text
//
//  Created by imht-ios on 14-5-29.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "UINavigationItem+ImhtNavi.h"
#import "YTMacro.h"

@implementation UINavigationItem (ImhtNavi)


- (void)addBackItemTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //适配IOS7 左边返回键距离边界太多的问题
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_SysVersion >= 7) {
        [spaceItem setWidth:-8];
    }
    
    [self setLeftBarButtonItems:@[spaceItem, backItem]];
    
}

- (void)addBackItemWithTitle:(NSString *)title
                      Target:(id)target
                      action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //适配IOS7 左边返回键距离边界太多的问题
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_SysVersion >= 7) {
        [spaceItem setWidth:-8];
    }
    
    [self setLeftBarButtonItems:@[spaceItem, backItem]];
}



- (void)addLeftItemTarget:(id)target
                   action:(SEL)action
                 andImage:(UIImage *)image
                  andSize:(CGSize )soursize
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //适配IOS7 键距离边界太多的问题
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_SysVersion >= 7) {
        [spaceItem setWidth:soursize.width];
    }else{
        [spaceItem setWidth:5];
    }
    
    [self setLeftBarButtonItems:@[spaceItem, backItem]];
}

- (void)addRightAddItemTarget:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"tianjiaItem"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self setRightBarButtonItem:backItem];
}


- (void)addrightitemReleseTarget:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self setRightBarButtonItem:backItem];
}

- (void)addRightItemTarget:(id)target action:(SEL)action andText:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.textColor = [UIColor yellowColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:action];
    [backItem setTintColor:[UIColor yellowColor]];
    //适配IOS7 键距离边界太多的问题
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_SysVersion >= 7) {
        [spaceItem setWidth:0];
    }else{
        [spaceItem setWidth:5];
    }
    
    [self setRightBarButtonItems:@[spaceItem, backItem]];
}

- (void)addRightItemTarget:(id)target action:(SEL)action andImageName:(NSString *)imageName andSize:(CGSize)soursize
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //适配IOS7 键距离边界太多的问题
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (IOS_SysVersion >= 7) {
        [spaceItem setWidth:soursize.width];
    }else{
        [spaceItem setWidth:5];
    }
    
    [self setRightBarButtonItems:@[spaceItem, backItem]];
}


@end
