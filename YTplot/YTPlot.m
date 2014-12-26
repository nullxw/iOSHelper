//
//  YTPlot.m
//  PlotTest
//
//  Created by 张英堂 on 14/10/31.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import "YTPlot.h"
#import <CoreGraphics/CoreGraphics.h>
#import "ShapeView.h"

static CFTimeInterval   const kDuration = 1.0;
static CGFloat          const kPointDiameter = 0.5;

#define kBOX_X  40
#define kBOX_Y  20
#define kBOX_W  20

@interface YTPlot ()
{
    CGFloat _maxValue;
    CGFloat _minValue;
    NSMutableArray *_pointArray;
}
@end


@implementation YTPlot

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.numArray = [NSMutableArray array];
        _pointArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self starDraw];
}

- (void)starDraw{
    if (self.axis_y_min == 0 && self.axis_y_max == 0) {
        [self getMinAndMaxValue];
    }else{
        _maxValue = self.axis_y_max;
        _minValue = self.axis_y_min;
    }
    
}

- (void)getMinAndMaxValue{
    
    CGFloat max = 0;
    CGFloat min = 0;

    for (int i = 0; i < self.numArray.count; i++) {

        plotModel *pModel = self.numArray[i];
        CGFloat num = pModel.value;
        
        if (i == 0) {
            max = num;
        }
        
        if (max < num) {
            max = num;
        }
        
        if (min > num) {
            min = num;
        }
    }
    NSInteger count = 0;
    for (int i = 0; i < 5; i++) {
        if (max > 10) {
            max  = max / 10;
            count ++;
        }
    }

    NSInteger temp = max + 1;
    max = temp * pow(10, count);
    
    _maxValue = max;
    _minValue = min;
}

-(void)drawRect:(CGRect)rect{

    if (self.lineStyle == nil) {
        self.lineStyle = [[plotLine alloc] init];
        self.lineStyle.lineColor = [UIColor ytColorWithRed:1 green:1 blue:1 alpha:0.5];
        self.lineStyle.lineWidth = 0.4f;
    }
    CGFloat sectionHight = (_maxValue - _minValue) / 5;
    
    CGContextRef textRef = UIGraphicsGetCurrentContext();
    CGContextClearRect(textRef, rect);

    UIGraphicsPushContext(textRef);
    CGContextSetRGBFillColor(textRef, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
    CGContextFillRect(textRef, self.bounds);
    UIGraphicsPopContext();

    if (self.numArray == nil) {
        NSException *exception = [NSException exceptionWithName:@"出错了" reason:@"请设置要画线的点" userInfo:nil];
        [exception raise];
    }
//先画 折线图的边框
    [self drawLineStar:CGPointMake(kBOX_X, rect.size.height - kBOX_Y) endPoint:CGPointMake(rect.size.width - kBOX_W,  rect.size.height - kBOX_Y) contextRef:textRef];
     [self drawLineStar:CGPointMake(kBOX_X, 20) endPoint:CGPointMake(kBOX_X, rect.size.height - kBOX_Y) contextRef:textRef];
    
//x 轴
    for (int i = 0; i < self.numArray.count; i ++) {
        plotModel *pModel = self.numArray[i];
        [self drawTextWithY:pModel.x_string point:CGPointMake((rect.size.width - kBOX_W - kBOX_X) / (self.numArray.count + 1) * (i + 1) + kBOX_X, rect.size.height - kBOX_Y) contextRef:textRef];
        [self drawPoint:CGPointMake((rect.size.width - kBOX_W - kBOX_X) / (self.numArray.count + 1) * (i + 1) + kBOX_X, rect.size.height - kBOX_Y) contextRef:textRef is_x:YES];
        
//        [self drawLineStar:CGPointMake((rect.size.width - kBOX_W - kBOX_X) / (self.numArray.count + 1) * (i + 1) + kBOX_X, rect.size.height - kBOX_Y) endPoint:CGPointMake((rect.size.width - kBOX_W - kBOX_X) / (self.numArray.count + 1) * (i + 1) + kBOX_X, 20) width:0.5f color:[UIColor ytColorWithRed:1 green:1 blue:1 alpha:0.3] contextRef:textRef];
    }
    
//y 轴
    for (int i = 0;  i <= 5; i++) {
        CGFloat num = i * sectionHight;
        NSString *sting = [NSString stringWithFormat:@"%.0f", num];
        [self drawTextWithX:sting point:CGPointMake(kBOX_X,  rect.size.height - kBOX_Y - (rect.size.height - kBOX_Y) / 6 * i) contextRef:textRef];
        
//        [self drawPoint:CGPointMake(kBOX_Y, (rect.size.height - kBOX_Y) / 6 * i) contextRef:textRef is_x:NO];
        if (i != 0) {
            [self drawDashLineStar:CGPointMake(kBOX_X, (rect.size.height - kBOX_Y) / 6 * i) endPoint:CGPointMake(rect.size.width - kBOX_W, (rect.size.height - kBOX_Y) / 6 * i) width:0.5f color:[UIColor ytColorWithRed:1 green:1 blue:1 alpha:0.3] contextRef:textRef];
        }
    }
    
//画线 -- 先取得各个点的坐标。然后统一划线
    for (int i = 0; i < self.numArray.count; i ++) {
        plotModel *pModel = self.numArray[i];
        CGFloat num = pModel.value;
        
        CGFloat y = rect.size.height - num / _maxValue * ((rect.size.height - kBOX_Y) / 6 * 5) - kBOX_Y;
        CGPoint sPoint = CGPointMake((rect.size.width - kBOX_W - kBOX_X) / (self.numArray.count + 1) * (i + 1) + kBOX_X, y);
        
        if (i != 0) {
            NSValue *nValue = [_pointArray lastObject];
            CGPoint nPoint = nValue.CGPointValue;
            if (nPoint.x != sPoint.x && nPoint.y != sPoint.y) {
                CGPoint bPoint = CGPointMake(sPoint.x - 10, nPoint.y);
                [_pointArray addObject:[NSValue valueWithCGPoint:bPoint]];
            }

        }
        
        NSValue *sValue = [NSValue valueWithCGPoint:sPoint];
        [_pointArray addObject:sValue];

    }
    
    [self showLinesAnimationBegin];//显示线条动画
}

- (void)showLinesAnimationBegin
{
    //添加path的UIView
    ShapeView  *pathShapeView = [[ShapeView alloc] init];
    pathShapeView.backgroundColor = [UIColor clearColor];
    pathShapeView.opaque = NO;
    pathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pathShapeView];
    
    //设置线条的颜色
    UIColor *pathColor = [UIColor redColor];
    pathShapeView.shapeLayer.fillColor = pathColor.CGColor;
    pathShapeView.shapeLayer.strokeColor = pathColor.CGColor;
    
    //创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    animation.duration = kDuration;
    [pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self updatePathsWithPathShapeView:pathShapeView];
}

- (void)updatePathsWithPathShapeView:(ShapeView *)pathShapeView
{
    if (_pointArray.count >= 2) {
        //设置路径的颜色和动画
        CGPoint point = [[_pointArray firstObject] CGPointValue];
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:point];
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:kPointDiameter / 2.0 startAngle:0.0 endAngle:2 * M_PI clockwise:YES]];
        [path fill];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [_pointArray count] - 1)];
        [_pointArray enumerateObjectsAtIndexes:indexSet
                                          options:0
                                       usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                           
                                           [path addLineToPoint:[pointValue CGPointValue]];
                                           [path appendPath:[UIBezierPath bezierPathWithArcCenter:[pointValue CGPointValue] radius:kPointDiameter / 2.0 startAngle:0.0 endAngle: M_PI clockwise:YES]];
                                           [path fill];
                                       }];
        path.usesEvenOddFillRule = YES;
        pathShapeView.shapeLayer.path = path.CGPath;
    }
    else {
        pathShapeView.shapeLayer.path = nil;
    }
}




- (void)drawPoint:(CGPoint)point contextRef:(CGContextRef)textRef is_x:(BOOL)isx{
    if (isx == YES) {
        [self drawLineStar:point endPoint:CGPointMake(point.x, point.y - 3) contextRef:textRef];
    }else{
        [self drawLineStar:point endPoint:CGPointMake(point.x + 3, point.y) contextRef:textRef];
    }
}

- (void)drawTextWithY:(NSString *)text point:(CGPoint)point contextRef:(CGContextRef)textRef{
    UIFont *font = [UIFont systemFontOfSize:11.0];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGPoint sPoint = CGPointMake(point.x - textSize.width / 2, point.y + 3);
    [self drawText:text point:sPoint contextRef:textRef];
}

- (void)drawTextWithX:(NSString *)text point:(CGPoint)point contextRef:(CGContextRef)textRef{
    UIFont *font = [UIFont systemFontOfSize:11.0];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGPoint sPoint = CGPointMake(point.x - 6 - textSize.width, point.y - textSize.height / 2);
    [self drawText:text point:sPoint contextRef:textRef];
}

- (void)drawText:(NSString *)text point:(CGPoint)point contextRef:(CGContextRef)textRef{
    CGContextSetLineWidth(textRef, 1.0);
    UIFont *font = [UIFont systemFontOfSize:11.0];
    [text drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor ytColorWithRed:116 green:116 blue:116 alpha:1]}];
}

- (void)drawLineStar:(CGPoint)sPoint endPoint:(CGPoint)ePoint contextRef:(CGContextRef)textRef{
    
    [self drawLineStar:sPoint endPoint:ePoint width:self.lineStyle.lineWidth color:self.lineStyle.lineColor contextRef:textRef];
}

- (void)drawLineStar:(CGPoint)sPoint endPoint:(CGPoint)ePoint width:(CGFloat)width color:(UIColor *)color contextRef:(CGContextRef)textRef{
    CGContextBeginPath(textRef);
    CGContextSetLineJoin(textRef, kCGLineJoinRound);
    CGContextSetLineCap(textRef , kCGLineCapRound);
    CGContextSetBlendMode(textRef, kCGBlendModeNormal);
    CGContextBeginPath(textRef);
    CGContextMoveToPoint(textRef, sPoint.x, sPoint.y);
    CGContextAddLineToPoint(textRef, ePoint.x, ePoint.y);
    CGContextSetLineWidth(textRef, width);
    CGContextSetAlpha(textRef, 1);
    CGContextSetStrokeColorWithColor(textRef, color.CGColor);
    
    CGContextStrokePath(textRef);
}

- (void)drawDashLineStar:(CGPoint)sPoint endPoint:(CGPoint)ePoint width:(CGFloat)width color:(UIColor *)color contextRef:(CGContextRef)textRef{
    CGContextBeginPath(textRef);
    CGContextSetLineWidth(textRef, width);
    CGContextSetStrokeColorWithColor(textRef, color.CGColor);
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(textRef, 0, lengths, 2);
    CGContextMoveToPoint(textRef, sPoint.x, sPoint.y);
    CGContextAddLineToPoint(textRef, ePoint.x,ePoint.y);
    CGContextStrokePath(textRef);
}




@end

#pragma mark - plotLine

@implementation plotLine


@end

#pragma mark - plotmodel
@implementation plotModel

@end


