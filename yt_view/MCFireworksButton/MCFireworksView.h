//
//  MCFireworksButton.h
//  MCFireworksButton
//
//  Created by sevennigth on 17/3/14.
//  Copyright (c) 2014 sevennigth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCFireworksView : UIView

@property (strong, nonatomic) UIImage *particleImage;
@property (assign, nonatomic) CGFloat particleScale;
@property (assign, nonatomic) CGFloat particleScaleRange;

- (void)animate;

@end
