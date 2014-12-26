//
//  YTCalendarView.h
//  CalendarView
//
//  Created by seven night on 5/8/13.
//  Copyright (c) 2014 visionhacker. All rights reserved.
//

#import "YTCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIView+convenience.h"
#import "UIView+DrawLine.h"
#import "ClockInModel.h"

@interface YTCalendarView ()
{
    CGFloat _dayHigth;
}
@property(nonatomic, strong) UIImageView *animationView_A;
@property(nonatomic, strong) UIImageView *animationView_B;

@property (nonatomic, strong) UILabel *labelCurrentMonth;

-(void)selectDate:(NSInteger)date;

-(void)showNextMonth;           //显示下一个月
-(void)showPreviousMonth;       //显示上一个月

@end

@implementation YTCalendarView

#pragma mark - Select Date
-(void)selectDate:(NSInteger)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    self.selectedDate = [gregorian dateFromComponents:comps];
    
    NSInteger selectedDateYear = [self.selectedDate year];
    NSInteger selectedDateMonth = [self.selectedDate month];
    NSInteger currentMonthYear = [self.currentMonth year];
    NSInteger currentMonthMonth = [self.currentMonth month];
    
    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:dateSelected:)]) [self.delegate calendarView:self dateSelected:self.selectedDate];
}

#pragma mark - Mark Dates
//NSArray can either contain NSDate objects or NSNumber objects with an NSInteger of the day.
-(void)markDates:(NSArray *)dates {
    self.markedDates = dates;
    
    [self setNeedsDisplay];
}


#pragma mark - Set date to now
-(void)reset {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: [NSDate date]];
    self.currentMonth = [gregorian dateFromComponents:components]; //clean month
    
    [self updateSize];
    [self setNeedsDisplay];
    [self.delegate calendarView:self switchedToMonth:[self.currentMonth month] targetHeight:self.calendarHeight animated:NO];
}

#pragma mark - Next & Previous
-(void)showNextMonth {
    self.selectedDate = nil;
    if (isAnimating) return;
    
    if ([self allowsNextMouth]) {
//        self.markedDates = nil;
        isAnimating = YES;
        prepAnimationNextMonth = YES;
        
        [self setNeedsDisplay];
        
        NSInteger lastBlock = [self.currentMonth firstWeekDayInMonth] + [self.currentMonth numDaysInMonth]-1;
        NSInteger numBlocks = [self numRows]*7;
        BOOL hasNextMonthDays = lastBlock<numBlocks;
        
        //Old month
        CGFloat oldSize = self.calendarHeight;
        UIImage *imageCurrentMonth = [self drawCurrentState];
        
        //New month
        self.currentMonth = [self.currentMonth offsetMonth:1];
        if ([self.delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight: animated:)]) [self.delegate calendarView:self switchedToMonth:[self.currentMonth month] targetHeight:self.calendarHeight animated:YES];
        prepAnimationNextMonth=NO;
        [self setNeedsDisplay];
        
        UIImage *imageNextMonth = [self drawCurrentState];
        CGFloat targetSize = fmaxf(oldSize, self.calendarHeight);
        UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kYTCalendarViewTopBarHeight, kYTCalendarViewWidth, targetSize-kYTCalendarViewTopBarHeight)];
        [animationHolder setClipsToBounds:YES];
        [self addSubview:animationHolder];
        
        //Animate
        if (self.animationView_A == nil) {
            self.animationView_A = [[UIImageView alloc] init];
            self.animationView_B = [[UIImageView alloc] init];
        }
        self.animationView_A.image = imageCurrentMonth;
        self.animationView_B.image = imageNextMonth;
        [animationHolder addSubview:_animationView_A];
        [animationHolder addSubview:_animationView_B];
    
        [self.animationView_A setFrame:CGRectMake(0, 0, imageCurrentMonth.size.width, imageCurrentMonth.size.height)];
        [self.animationView_B setFrame:CGRectMake(0, 0, imageNextMonth.size.width, imageNextMonth.size.height)];

        if (hasNextMonthDays) {
            self.animationView_B.frameY = self.animationView_A.frameY + self.animationView_A.frameHeight - (_dayHigth+3);
        } else {
            self.animationView_B.frameY = self.animationView_A.frameY + self.animationView_A.frameHeight -3;
        }
        
        //Animation
        [UIView animateWithDuration:0.35f
                         animations:^{
                             [self updateSize];
                             if (hasNextMonthDays) {
                                 _animationView_A.frameY = -_animationView_A.frameHeight + _dayHigth+3;
                             } else {
                                 _animationView_A.frameY = -_animationView_A.frameHeight + 3;
                             }
                             _animationView_B.frameY = 0;
                         }
                         completion:^(BOOL finished) {
                             [animationHolder removeFromSuperview];
                             [self animationRest];
                         }
         ];
    }
}

-(void)showPreviousMonth {
    self.selectedDate = nil;
    if (isAnimating) return;
    
    if ([self allowsPrevious])
    {
        isAnimating = YES;
//        self.markedDates = nil;
        //Prepare current screen
        prepAnimationPreviousMonth = YES;
        [self setNeedsDisplay];
        BOOL hasPreviousDays = [self.currentMonth firstWeekDayInMonth] > 1;
        CGFloat oldSize = self.calendarHeight;
        UIImage *imageCurrentMonth = [self drawCurrentState];
        
        //Prepare next screen
        self.currentMonth = [self.currentMonth offsetMonth:-1];
        if ([self.delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [self.delegate calendarView:self switchedToMonth:[self.currentMonth month] targetHeight:self.calendarHeight animated:YES];
        prepAnimationPreviousMonth=NO;
        [self setNeedsDisplay];
        UIImage *imagePreviousMonth = [self drawCurrentState];
        
        float targetSize = fmaxf(oldSize, self.calendarHeight);
        UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kYTCalendarViewTopBarHeight, kYTCalendarViewWidth, targetSize - kYTCalendarViewTopBarHeight)];
        
        [animationHolder setClipsToBounds:YES];
        [self addSubview:animationHolder];
        
        //Animate
        if (self.animationView_A == nil) {
            self.animationView_A = [[UIImageView alloc] init];
            self.animationView_B = [[UIImageView alloc] init];
        }
        self.animationView_A.image = imageCurrentMonth;
        self.animationView_B.image = imagePreviousMonth;
        [animationHolder addSubview:_animationView_A];
        [animationHolder addSubview:_animationView_B];
        
        [self.animationView_A setFrame:CGRectMake(0, 0, imageCurrentMonth.size.width, imageCurrentMonth.size.height)];
        [self.animationView_B setFrame:CGRectMake(0, 0, imagePreviousMonth.size.width, imagePreviousMonth.size.height)];

        if (hasPreviousDays) {
            _animationView_B.frameY = _animationView_A.frameY - (_animationView_B.frameHeight-_dayHigth) + 3;
        } else {
            _animationView_B.frameY = _animationView_A.frameY - _animationView_B.frameHeight + 3;
        }
        [UIView animateWithDuration:.35
                         animations:^{
                             [self updateSize];
                             
                             if (hasPreviousDays) {
                                 _animationView_A.frameY = _animationView_B.frameHeight-(_dayHigth+3);
                                 
                             } else {
                                 _animationView_A.frameY = _animationView_B.frameHeight-3;
                             }
                             
                             _animationView_B.frameY = 0;
                         }
                         completion:^(BOOL finished) {
                             [animationHolder removeFromSuperview];
                             [self animationRest];
                         }
         ];
    }
}
//动画完成后，恢复状态
- (void)animationRest{
    [self.animationView_A removeFromSuperview];
    [self.animationView_B removeFromSuperview];
    self.animationView_A.image = nil;
    self.animationView_B.image = nil;
    isAnimating=NO;
}

#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

-(CGFloat)calendarHeight {
    return kYTCalendarViewTopBarHeight + [self numRows]*(_dayHigth+2) + 1;
}

-(NSInteger)numRows {
    CGFloat lastBlock = [self.currentMonth numDaysInMonth] + ([self.currentMonth firstWeekDayInMonth]-1);
    return ceilf(lastBlock/7);
}


#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    NSInteger firstWeekDay = [self.currentMonth firstWeekDayInMonth] - 1; //-1 because weekdays begin at 1, not 0
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy  MMMM"];
    self.labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];

    [self.currentMonth firstWeekDayInMonth];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGRect rectangle = CGRectMake(0, 0, self.frame.size.width, kYTCalendarViewTopBarHeight);
    CGContextAddRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
//    //Arrows
//    int arrowSize = 12;
//    int xmargin = 20;
//    int ymargin = 18;
    
    CGContextBeginPath(context);
    
    //Arrow left
    if ([self allowsPrevious]) {
//        CGPoint opoint = CGPointMake(xmargin+arrowSize/1.5, ymargin);
//        CGPoint tpoint = CGPointMake(xmargin+arrowSize/1.5, ymargin+arrowSize);
//        CGPoint thpoint = CGPointMake(xmargin, ymargin+arrowSize/2);
//        
//        [self drawTrigonWith:context pointOne:opoint pointTwo:tpoint pointThree:thpoint fillColor:[UIColor blackColor]];
    }
    //Arrow right
    if ([self allowsNextMouth]) {
//        CGPoint opoint = CGPointMake(self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
//        CGPoint tpoint = CGPointMake(self.frame.size.width-xmargin, ymargin+arrowSize/2);
//        CGPoint thpoint = CGPointMake(self.frame.size.width-(xmargin+arrowSize/1.5), ymargin+arrowSize);
//        
//        [self drawTrigonWith:context pointOne:opoint pointTwo:tpoint pointThree:thpoint fillColor:[UIColor blackColor]];
    }
    //Weekdays
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE";
    //always assume gregorian with monday first
    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    
    [weekdays moveObjectFromIndex:0 toIndex:6];

    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0x383838"].CGColor);
    
    for (NSInteger i = 0; i < [weekdays count]; i++) {
        NSString *weekdayValue = (NSString *)[weekdays objectAtIndex:i];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];
        parStyle.alignment = NSTextAlignmentCenter;
        parStyle.lineBreakMode = NSLineBreakByClipping;
        
        [weekdayValue drawInRect:CGRectMake(i*(kYTCalendarViewDayWidth+2), 40, kYTCalendarViewDayWidth+2, 20)
                  withAttributes:@{NSFontAttributeName:font,
                                   NSParagraphStyleAttributeName:parStyle}];
    }
    
    NSInteger numRows = [self numRows];
    CGContextSetAllowsAntialiasing(context, NO);
    
    //Grid background
    CGFloat gridHeight = numRows*(_dayHigth+2)+1;
//    CGRect rectangleGrid = CGRectMake(0, kYTCalendarViewTopBarHeight, self.frame.size.width, gridHeight);
//
//    CGContextAddRect(context, rectangleGrid);
//    CGContextSetFillColorWithColor(context, self.backColor.CGColor);
//    CGContextFillPath(context);
    
    //Grid white lines
    if (self.hasBorder) {
        [self drawBoder:context gridHeight:gridHeight numRows:numRows];
    }
    //Draw days
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0x383838"].CGColor);
    
    NSInteger numBlocks = numRows * 7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    NSInteger currentMonthNumDays = [self.currentMonth numDaysInMonth];
    NSInteger prevMonthNumDays = [previousMonth numDaysInMonth];
    
    NSInteger selectedDateBlock = ([self.selectedDate day]-1)+firstWeekDay;
    
    //prepAnimationPreviousMonth nog wat mee doen
    
    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate!=nil) {
        isSelectedDatePreviousMonth = ([self.selectedDate year]==[self.currentMonth year] && [self.selectedDate month]<[self.currentMonth month]) || [self.selectedDate year] < [self.currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([self.selectedDate year]==[self.currentMonth year] && [self.selectedDate month]>[self.currentMonth month]) || [self.selectedDate year] > [self.currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        NSInteger lastPositionPreviousMonth = firstWeekDay-1;
        selectedDateBlock=lastPositionPreviousMonth-([self.selectedDate numDaysInMonth]-[self.selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [self.currentMonth numDaysInMonth] + (firstWeekDay-1) + [self.selectedDate day];
    }
    
    
    NSDate *todayDate = [NSDate date];
    NSInteger todayBlock = -1;
    
    if ([todayDate month] == [self.currentMonth month] && [todayDate year] == [self.currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
    }
    
    for (NSInteger i = 0; i < [self.markedDates count]; i++) {
        id markedDateObj = [self.markedDates objectAtIndex:i];
        
        YTMarkModel *targetModel = nil;
        
        if ([markedDateObj isKindOfClass:[YTMarkModel class]] || [markedDateObj isKindOfClass:[ClockInModel class]]) {
            targetModel = (YTMarkModel *)markedDateObj;
        }
        if (targetModel != nil && targetModel.MMonth == self.currentMonth.month && targetModel.MYear == self.currentMonth.year) {
            
            NSInteger targetBlock = firstWeekDay + (targetModel.MDay - 1);
            NSInteger targetColumn = targetBlock % 7;
            NSInteger targetRow = targetBlock / 7;
            CGRect rectangleGrid = [self rectWithColumn:targetColumn row:targetRow];
            
            [self drawMark:targetModel.markStyle rect:rectangleGrid fillColor:targetModel.MColor contextRef:context];
        }
    }
    
    for (NSInteger i = 0; i < numBlocks; i++) {
        NSInteger targetDate = i;
        NSInteger targetColumn = i % 7;
        NSInteger targetRow = i / 7;
        
        CGRect rectangleGrid = [self rectWithColumn:targetColumn row:targetRow];
        
        NSInteger targetX = targetColumn * (kYTCalendarViewDayWidth+2);
        NSInteger targetY = kYTCalendarViewTopBarHeight + targetRow * (_dayHigth + 2) + 1;
        
        // BOOL isCurrentMonth = NO;
        if (i < firstWeekDay) { //previous month
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            NSString *hex = (isSelectedDatePreviousMonth) ? @"0x383838" : @"aaaaaa";
            
            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:hex].CGColor);
        } else if (i >= (firstWeekDay+currentMonthNumDays)) { //next month
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
            NSString *hex = (isSelectedDateNextMonth) ? @"0x383838" : @"aaaaaa";
            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:hex].CGColor);
        } else { //current month
            // isCurrentMonth = YES;
            targetDate = (i-firstWeekDay)+1;
            NSString *hex = (isSelectedDatePreviousMonth || isSelectedDateNextMonth) ? @"0xaaaaaa" : @"0x383838";
            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:hex].CGColor);
        }
        
        NSString *date = [NSString stringWithFormat:@"%li",(long)targetDate];
        
        //draw selected date
        if (self.selectedDate && i == selectedDateBlock) {
            
            [self drawMark:self.selectedMarkStyle rect:rectangleGrid fillColor:self.selectedColor contextRef:context];
            
        } else if (todayBlock == i) {
            
            [self drawMark:self.todayMarkStyle rect:rectangleGrid fillColor:self.todayMarkColor contextRef:context];
        }
        
        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];
        parStyle.alignment = NSTextAlignmentCenter;
        parStyle.lineBreakMode = NSLineBreakByClipping;
        
        UIColor *draColor = nil;
        if ((i < 7 && date.integerValue > 7) || (i > 28 && date.integerValue <7)) {
            draColor = [UIColor grayColor];
        }else{
            draColor = [UIColor blackColor];
        }
        CGSize fontSize = [date sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gill Sans" size:17]}];
        [date drawInRect:CGRectMake(targetX, targetY + _dayHigth/2 - fontSize.height/2, kYTCalendarViewDayWidth, fontSize.height)
          withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gill Sans" size:17],
                           NSParagraphStyleAttributeName:parStyle,
                           NSForegroundColorAttributeName:draColor
                           }];
    }
}

//根据第几个返回 cgrect
- (CGRect)rectWithColumn:(NSInteger)column row:(NSInteger)row{
    
    NSInteger targetX = column * (kYTCalendarViewDayWidth + 1) + column * 1 + 1.5;
    NSInteger targetY = kYTCalendarViewTopBarHeight + row * (_dayHigth+1) + row * 1 + 1.5;
    CGRect rectangleGrid = CGRectMake(targetX,targetY, kYTCalendarViewDayWidth, _dayHigth);
    
    return rectangleGrid;
}

//画标记的 图形
- (void)drawMark:(YTMarkStyle)style rect:(CGRect)rect fillColor:(UIColor*)color contextRef:(CGContextRef)context{
    
    rect.origin.x = (rect.size.width - rect.size.height) / 2 + rect.origin.x;
    rect.size.width = rect.size.height;
    
    rect = CGRectMake(rect.origin.x + 5, rect.origin.y + 5, rect.size.width - 10, rect.size.height - 10);

    CGContextSetFillColorWithColor(context, color.CGColor);
    switch (style) {
        case markRound:
        {
            CGContextAddEllipseInRect(context, rect);
        }
            break;
        case markRect:
        {
            CGContextAddRect(context, rect);

        }
            break;
        case markRoundBorder:
        {
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextSetLineWidth(context, 1.0f);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextStrokeEllipseInRect(context, rect);
        }
            break;
        case markStyleNo:{
            
        }
        default:
            break;
    }
    CGContextFillPath(context);

    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
}

//是否有下一个月
- (BOOL)allowsNextMouth{
    if (self.maxDate == nil) {
        return YES;
    }
    if (self.maxDate.year <= self.currentMonth.year) {
        if (self.maxDate.month <= self.currentMonth.month) {
            return NO;
        }else{
            return YES;
        }
    }else if (self.maxDate.year > self.currentMonth.year){
        NSLog(@"ytCalenderView: maxdate 设置错误，请检查");
        return NO;
    }
    return YES;
}

//是否有上一个月
- (BOOL)allowsPrevious{
    if (self.minDate == nil) {
        return YES;
    }
    if (self.minDate.year == self.currentMonth.year) {
        if (self.minDate.month < self.currentMonth.month) {
            return YES;
        }else{
            return NO;
        }
    }else if(self.minDate.year > self.currentMonth.year){
        NSLog(@"ytCalenderView: mindate 设置错误，请检查");
        return NO;
    }
    return YES;
}

// 画边框
- (void)drawBoder:(CGContextRef)context gridHeight:(CGFloat)gridHeight numRows:(CGFloat)numRows{
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kYTCalendarViewTopBarHeight+1);
    CGContextAddLineToPoint(context, kYTCalendarViewWidth, kYTCalendarViewTopBarHeight+1);
    for (NSInteger i = 1; i < 7; i++) {
        CGContextMoveToPoint(context, i*(kYTCalendarViewDayWidth+1)+i*1-1, kYTCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kYTCalendarViewDayWidth+1)+i*1-1, kYTCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kYTCalendarViewTopBarHeight + i*(_dayHigth+1)+i*1+1);
        CGContextAddLineToPoint(context, kYTCalendarViewWidth, kYTCalendarViewTopBarHeight+i*(_dayHigth+1)+i*1+1);
    }
    
    CGContextStrokePath(context);
    
    //Grid dark lines
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"0xcfd4d8"].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kYTCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kYTCalendarViewWidth, kYTCalendarViewTopBarHeight);
    for (NSInteger i = 1; i < 7; i++) {
        //columns
        CGContextMoveToPoint(context, i*(kYTCalendarViewDayWidth+1) + i*1, kYTCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kYTCalendarViewDayWidth+1) + i*1, kYTCalendarViewTopBarHeight+gridHeight);
        
        if (i > numRows - 1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kYTCalendarViewTopBarHeight+i*(_dayHigth+1)+i*1);
        CGContextAddLineToPoint(context, kYTCalendarViewWidth, kYTCalendarViewTopBarHeight+i*(_dayHigth+1)+i*1);
    }
    CGContextMoveToPoint(context, 0, gridHeight+kYTCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kYTCalendarViewWidth, gridHeight + kYTCalendarViewTopBarHeight);
    
    CGContextStrokePath(context);
    CGContextSetAllowsAntialiasing(context, YES);
}


#pragma mark - Draw image for animation
-(UIImage *)drawCurrentState {
    CGFloat targetHeight = kYTCalendarViewTopBarHeight + [self numRows] * (_dayHigth+2) + 1;
    
    UIGraphicsBeginImageContext(CGSizeMake(kYTCalendarViewWidth, targetHeight - kYTCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kYTCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kYTCalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        self.layer.shouldRasterize = YES;
        
        self.hasBorder = YES;
        self.backColor = [UIColor whiteColor];
        
        self.todayMarkColor = [UIColor colorWithRed:99/255.0 green:248/255.0 blue:87/255.0 alpha:1];
        self.todayMarkStyle = markRound;
        
        self.selectedColor = [UIColor clearColor];
        self.selectedMarkStyle = markStyleNo;
        
        _dayHigth = kYTCalendarViewDayHeight;
        _dayHightScale = 1;
        
        isAnimating = NO;
        self.labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kYTCalendarViewWidth - 80, 40)];
        [self addSubview:self.labelCurrentMonth];
        self.labelCurrentMonth.backgroundColor=[UIColor clearColor];
        self.labelCurrentMonth.font = [UIFont fontWithName:@"Gill Sans-Bold" size:17];
        self.labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x383838"];
        self.labelCurrentMonth.textAlignment = NSTextAlignmentCenter;
        
        //添加界面手势
        UISwipeGestureRecognizer *leftSwiGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMothod:)];
        leftSwiGest.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwiGest];
        
        UISwipeGestureRecognizer *rightSwiGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMothod:)];
        rightSwiGest.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwiGest];
        
        UISwipeGestureRecognizer *downSwiGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMothod:)];
        downSwiGest.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:downSwiGest];
        
        UISwipeGestureRecognizer *upSwiGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMothod:)];
        upSwiGest.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:upSwiGest];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGest];
        
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1];
    }
    
    return self;
}

- (void)setDayHightScale:(CGFloat)dayHightScale{
    _dayHightScale = dayHightScale;
    _dayHigth = _dayHigth * _dayHightScale;
}

//轻扫 手势方法
-(void)nextMothod:(UISwipeGestureRecognizer *)gest{
    if (gest.direction == UISwipeGestureRecognizerDirectionRight || gest.direction == UISwipeGestureRecognizerDirectionDown) {
        [self showPreviousMonth];
        
    }else if(gest.direction == UISwipeGestureRecognizerDirectionLeft || gest.direction == UISwipeGestureRecognizerDirectionUp){
        [self showNextMonth];
    }
}
//点击手势
- (void)tapAction:(UITapGestureRecognizer *)gest{
    if (gest.state == UIGestureRecognizerStateEnded) {
        CGPoint touchPoNSInteger = [gest locationInView:self];;
        
            //Touch a specific day
            if (touchPoNSInteger.y > kYTCalendarViewTopBarHeight) {
                CGFloat xLocation = touchPoNSInteger.x;
                CGFloat yLocation = touchPoNSInteger.y-kYTCalendarViewTopBarHeight;
                
                NSInteger column = floorf(xLocation/(kYTCalendarViewDayWidth+2));
                NSInteger row = floorf(yLocation/(_dayHigth+2));
                
                NSInteger blockNr = (column+1)+row*7;
                NSInteger firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
                NSInteger date = blockNr-firstWeekDay;
                [self selectDate:date];
                
                return;
            }
        
            CGRect rectArrowLeft = CGRectMake(0, 0, 50, 40);
            CGRect rectArrowRight = CGRectMake(self.frame.size.width-50, 0, 50, 40);
            
            //Touch either arrows or month in middle
            if (CGRectContainsPoint(rectArrowLeft, touchPoNSInteger)) {
                [self showPreviousMonth];
            } else if (CGRectContainsPoint(rectArrowRight, touchPoNSInteger)) {
                [self showNextMonth];
            } else if (CGRectContainsPoint(self.labelCurrentMonth.frame, touchPoNSInteger)) {
                //Detect touch in current month
                NSInteger currentMonthIndex = [self.currentMonth month];
                NSInteger todayMonth = [[NSDate date] month];
                [self reset];
                if ((todayMonth != currentMonthIndex) && [self.delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]){
                    [self.delegate calendarView:self switchedToMonth:[self.currentMonth month] targetHeight:self.calendarHeight animated:NO];
                }
            }
        }
}

@end

#pragma mark -

@implementation YTMarkModel : NSObject

-(instancetype)init{
    self = [super init];
    if (self) {
        self.MDay = [NSDate date].day;
        self.MYear = [NSDate date].year;
        self.MMonth = [NSDate date].month;
        self.MColor = [UIColor redColor];
        self.markState = markStateNO;
    }
    return self;
}

@end




