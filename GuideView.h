//
//  GuideView.h
//  mall
//
//  Created by megvii on 14-9-27.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

//新手引导页面
@interface GuideView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) VoidBlock_id finshBlcok;

+ (void)statr;

@end
