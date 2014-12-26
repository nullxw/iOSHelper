//
//  ImhtAnimation.m
//  text
//
//  Created by imht-ios on 14-6-4.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "ImhtAnimation.h"

@implementation ImhtAnimation


+ (CATransition *)moveToTopAnimation
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBotto
    
    return transition;
}

+ (CATransition *)animationOut
{
    CATransition* transition = [CATransition animation];

    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    return transition;
}

+ (CAAnimation *)animationWaggle:(UIView *)view repeatCount:(NSInteger)count
{
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    an.duration      = 0.2;
    an.repeatCount   = count;
    an.autoreverses  = YES;
    an.fromValue     = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, -0.1, 0.0, 0.0, 0.03)];
    an.toValue       = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, 0.1, 0.0, 0.0, 0.03)];
    
    return an;
}

                       
@end
