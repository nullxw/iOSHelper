//
//  CircleView.m
//  mall
//
//  Created by 张英堂 on 14/10/29.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()

@property (nonatomic) CAShapeLayer *circleLayer;
@property (nonatomic, assign) BOOL allRoll;

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allRoll = YES;
        NSAssert(frame.size.width == frame.size.height, @"A circle must have the same height and width.");
        [self addCircleLayer];
        self.circleLayer.strokeEnd = 0.01;

    }
    return self;
}


#pragma mark - Private Instance methods

- (void)addCircleLayer
{
    CGFloat lineWidth = 1.f;
    CGFloat radius = CGRectGetWidth(self.bounds)/2 - lineWidth/2;
    self.circleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius * 2);
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       cornerRadius:radius].CGPath;
    
    self.circleLayer.strokeColor = [UIColor ytColorWithRed:33 green:191 blue:181 alpha:1].CGColor;
    self.circleLayer.fillColor = [UIColor whiteColor].CGColor;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:self.circleLayer];
    
//    self.rollLayer = [CAShapeLayer layer];
//    self.rollLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
//                                                     cornerRadius:radius].CGPath;
//    self.rollLayer.strokeColor = self.tintColor.CGColor;
//    self.rollLayer.fillColor = nil;
//    self.rollLayer.lineWidth = lineWidth;
//    self.rollLayer.lineCap = kCALineCapRound;
//    self.rollLayer.lineJoin = kCALineJoinRound;
//    self.rollLayer.strokeEnd = 0.2f;
    
}

- (void)setStrokeValue:(CGFloat)value{
//    if (self.circleLayer.superlayer == nil && value == 0) {
//        [self.rollLayer removeFromSuperlayer];
//        [self.layer addSublayer:self.circleLayer];
//    }
//    if (self.circleLayer.superlayer) {
    if (self.allRoll == YES) {

        self.circleLayer.strokeEnd = value;
    }
    if (self.allRoll == NO && value == 0) {
        self.allRoll = YES;
    }
//    }
    
}


- (void)startRoll{
    
    self.allRoll = NO;
    self.circleLayer.strokeEnd = 0.8f;

//    [self.circleLayer removeFromSuperlayer];
//    if (self.rollLayer.superlayer == nil) {
//        [self.layer addSublayer:self.rollLayer];
//    }
//    self.rollLayer.transform = CATransform3DIdentity;
//
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 2;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

//在一个圆内生成一个点
#define PAI      M_PI * 2 / 360
- (CGVector)getXYWith:(float)r
{
    CGVector vector = CGVectorMake(0.0, 0.0);
    double x = 0.0;
    double y = 0.0;
    int k = arc4random() % (int)r;
    int angle = arc4random() % 360;
    double temp = PAI * angle;
    x = r + cos(temp) * k;
    y = r - sin(temp) * k;
    vector.dx = x;
    vector.dy = y;
   
    return vector;
}


@end
