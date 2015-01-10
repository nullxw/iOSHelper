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
#import "YTDayLabel.h"
#import "YTMacro.h"

@interface YTCalendarView ()
{
    CGFloat _dayHigth;
}
@property(nonatomic, strong) UIImageView *animationView_A;
@property(nonatomic, strong) UIImageView *animationView_B;

@property (nonatomic, strong) UILabel *labelCurrentMonth;
@property (nonatomic, strong) NSMutableArray *currentMonthMarks;

@property (nonatomic, strong) NSMutableArray *dayLabelArray;

//-(void)selectDate:(NSInteger)date;

-(void)showNextMonth;           //显示下一个月
-(void)showPreviousMonth;       //显示上一个月

@end

@implementation YTCalendarView

#pragma mark - Select Date
-(void)showPreviousMonth{
    self.selectedDate = nil;
    if (isAnimating) return;
    
    if ([self allowsPrevious]){
        self.currentMonth = [self.currentMonth offsetMonth:-1];
        [self creatDayView];
        [self screenMarkModel];

    }
}

-(void)showNextMonth{
    self.selectedDate = nil;
    if (isAnimating) return;

    if ([self allowsNextMouth]) {
        self.currentMonth = [self.currentMonth offsetMonth:1];
        [self creatDayView];
        [self screenMarkModel];

    }
}

#pragma mark - Mark Dates
//NSArray can either contain NSDate objects or NSNumber objects with an NSInteger of the day.
-(void)markDates:(NSArray *)dates {
    self.markedDates = dates;
    
    [self.currentMonthMarks removeAllObjects];
    
    [self screenMarkModel];
}

- (void)screenMarkModel{
    for (YTMarkModel *model in self.markedDates) {
        if (model.MMonth == self.currentMonth.month && model.MYear == self.currentMonth.year) {
            [self.currentMonthMarks addObject:model];
        }
    }
    
    [self drawMarkDay];
}

//动画完成后，恢复状态
- (void)animationRest{
    [self.animationView_A removeFromSuperview];
    [self.animationView_B removeFromSuperview];
    self.animationView_A.image = nil;
    self.animationView_B.image = nil;
    isAnimating=NO;
}

// 每天的按钮 事件
- (void)dayAction:(YTDayLabel *)sender{
    if (sender.isCurrutMonth) {
        self.selectedDate = [NSDate dateWithYear:self.currentMonth.year month:self.currentMonth.month day:sender.dateDayString.integerValue];
        
        if ([self.delegate respondsToSelector:@selector(calendarView:dateSelected:clockModel:)]){
             [self.delegate calendarView:self dateSelected:self.selectedDate clockModel:sender.model];
        }
        
    }else{
        if (sender.dateDayString.integerValue > 20) {
            [self showPreviousMonth];
        }else{
            [self showNextMonth];
        }
    }
}

#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = self.calendarHeight;
}

-(CGFloat)calendarHeight {
    return kYTCalendarViewTopBarHeight + [self numRows]*(_dayHigth+2) + 1;
}

-(NSInteger)numRows {
    CGFloat lastBlock = [self.currentMonth numDaysInMonth] + ([self.currentMonth firstWeekDayInMonth]);
    return ceilf(lastBlock/7);
}

- (void)creatDayView{
    
    NSInteger firstWeekDay = [self.currentMonth firstWeekDayInMonth]; //-1 because weekdays begin at 1, not 0
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy  MMMM"];
    self.labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];
    
    NSInteger numRows = [self numRows];
    NSInteger numBlocks = numRows * 7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    NSInteger currentMonthNumDays = [self.currentMonth numDaysInMonth];
    NSInteger prevMonthNumDays = [previousMonth numDaysInMonth];
    
    for (NSInteger i = 0; i < self.dayLabelArray.count; i++) {
        if (i <= numBlocks) {
            NSInteger targetDate = i;
            NSInteger targetColumn = i % 7;
            NSInteger targetRow = i / 7;
            
            CGRect rectangleGrid = [self rectWithColumn:targetColumn row:targetRow];
            
            // BOOL isCurrentMonth = NO;
            if (i < firstWeekDay) { //previous month
                targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            } else if (i >= (firstWeekDay+currentMonthNumDays)) { //next month
                targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
            } else { //current month
                // isCurrentMonth = YES;
                targetDate = (i-firstWeekDay)+1;
            }
            
            NSString *dateString = [NSString stringWithFormat:@"%li",(long)targetDate];
            
            YTDayLabel *dayLabel = self.dayLabelArray[i];
            if (dayLabel.superview == nil) {
                [self addSubview:dayLabel];
            }
            
            [dayLabel setFrame:rectangleGrid];
            [dayLabel setDateDayString:dateString];
            
            if ((i < 7 && dateString.integerValue > 7) || (i > 28 && dateString.integerValue <7)) {
                [dayLabel setTextColor:YT_ColorWithRGB(116, 116, 116, 0.3)];
                [dayLabel setIsCurrutMonth:NO];
            }else{
                [dayLabel setTextColor:[UIColor blackColor]];
                [dayLabel setIsCurrutMonth:YES];
            }
        }else{
            YTDayLabel *dayLabel = self.dayLabelArray[i];
            if (dayLabel.superview != nil) {
                [dayLabel removeFromSuperview];
            }
        }
    }
    [self updateSize];
}

- (void)drawMarkDay{
    
    for (NSInteger i = 0; i < self.dayLabelArray.count; i++) {
        YTDayLabel *dayLabel = self.dayLabelArray[i];
        if (dayLabel.superview != nil) {
            [dayLabel clearAllEffect];
        }
    }
    
    NSInteger firstWeekDay = [self.currentMonth firstWeekDayInMonth];
    
    for (NSInteger i = 0; i < [self.currentMonthMarks count]; i++) {
        id markedDateObj = [self.currentMonthMarks objectAtIndex:i];
        
        YTMarkModel *targetModel = nil;
        
        if ([markedDateObj isKindOfClass:[YTMarkModel class]]) {
            targetModel = (YTMarkModel *)markedDateObj;
        }
        
        if (targetModel != nil && targetModel.MMonth == self.currentMonth.month && targetModel.MYear == self.currentMonth.year) {
            
            NSInteger targetBlock = firstWeekDay + targetModel.MDay - 1;    //每一天的从 0 开始，而非 1
            
            YTDayLabel *dayLabel = self.dayLabelArray[targetBlock];
            [dayLabel setModel:targetModel];
        }
    }
}

//根据第几个返回 cgrect
- (CGRect)rectWithColumn:(NSInteger)column row:(NSInteger)row{
    
    NSInteger targetX = column * (kYTCalendarViewDayWidth + 1) + column * 1 + 1.5;
    NSInteger targetY = kYTCalendarViewTopBarHeight + row * (_dayHigth+1) + row * 1 + 1.5;
    CGRect rectangleGrid = CGRectMake(targetX,targetY, kYTCalendarViewDayWidth, _dayHigth);
    
    return rectangleGrid;
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
        self.currentMonthMarks = [NSMutableArray arrayWithCapacity:31];
        
        self.hasBorder = YES;
        self.backColor = [UIColor whiteColor];
        
        self.todayMarkColor = [UIColor colorWithRed:99/255.0 green:248/255.0 blue:87/255.0 alpha:1];
        self.todayMarkStyle = markRound;
        
        self.selectedColor = [UIColor clearColor];
        self.selectedMarkStyle = markStyleNo;
        
        _dayHigth = kYTCalendarViewDayHeight;
        _dayHightScale = 1;
        
        self.currentMonth = [NSDate date];
        
        isAnimating = NO;
        self.labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kYTCalendarViewWidth - 80, 40)];
        [self addSubview:self.labelCurrentMonth];
        self.labelCurrentMonth.backgroundColor=[UIColor clearColor];
        self.labelCurrentMonth.font = [UIFont fontWithName:@"Gill Sans-Bold" size:17];
        self.labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x383838"];
        self.labelCurrentMonth.textAlignment = NSTextAlignmentCenter;
        
        WeekDayBar *weekBar = [[WeekDayBar alloc] initWithFrame:CGRectMake(0, 40, kYTCalendarViewWidth, 20)];
        [self addSubview:weekBar];
        
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
        
    
        self.dayLabelArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            YTDayLabel *label = [[YTDayLabel alloc] initWithFrame:CGRectZero];
            [self.dayLabelArray addObject:label];
            [label addTarget:self action:@selector(dayAction:) forControlEvents:UIControlEventTouchUpInside];
            [label setTag:i];
        }
        
        [self creatDayView];
    }
    
    return self;
}

- (void)setDayHightScale:(CGFloat)dayHightScale{
    _dayHightScale = dayHightScale;
    _dayHigth = _dayHigth * _dayHightScale;
    [self creatDayView];
}

//轻扫 手势方法
-(void)nextMothod:(UISwipeGestureRecognizer *)gest{
    if (gest.direction == UISwipeGestureRecognizerDirectionRight || gest.direction == UISwipeGestureRecognizerDirectionDown) {
        [self showPreviousMonth];
        
    }else if(gest.direction == UISwipeGestureRecognizerDirectionLeft || gest.direction == UISwipeGestureRecognizerDirectionUp){
        [self showNextMonth];
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


#pragma mark -

@implementation WeekDayBar : UIView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *WeekArray = @[@"周天", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        for (NSInteger i = 0; i < WeekArray.count; i++) {
            
            CGRect rect = CGRectMake(i*(kYTCalendarViewDayWidth+2), 0, kYTCalendarViewDayWidth+2, 20);
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            NSString *string = WeekArray[i];
            
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            [label setText:string];
            [label setTextColor:[UIColor grayColor]];
            [label setFont:font];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [self addSubview:label];
        }
    }
    return self;
}

@end
