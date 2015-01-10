//
//  YTDayLabel.m
//  KoalaPerson
//
//  Created by 张英堂 on 14/12/17.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import "YTDayLabel.h"
#import "ClockInModel.h"

@interface YTDayLabel ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation YTDayLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];

        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        [self.textLabel setFont:[UIFont fontWithName:@"Gill Sans" size:17]];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    [self.textLabel setFrame:self.bounds];
    [self.imageView setFrame:self.bounds];
}

- (void)setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        _textColor = textColor;
        
        [self.textLabel setTextColor:_textColor];
    }
}

- (void) setDateDayString:(NSString *)dateDayString{
    _dateDayString = dateDayString;
    [self.textLabel setText:_dateDayString];
}

- (void)setModel:(YTMarkModel *)model{
    if (_model != model) {
        _model = model;
        
        [self drawMark:model];
    }
}

- (void)clearAllEffect{
    self.model = nil;
    self.imageView.image = nil;
}

//画标记的 图形
- (void)drawMark:(YTMarkModel*)style{
    
    NSString *imageName = nil;
    
    switch (style.markState) {
        case markStateError:
        {
            imageName = @"kaoqing_later";
        }
            break;
        case markStateOK:
        {
            imageName = @"kaoqing_normal";

        }
            break;
        case markStateNO:
        {
            imageName = @"today";

        }
            break;
        case markStateWait:{
            imageName = @"kaoqing_putin";
        }
            break;
        default:
            break;
    }

    UIImage *image = [UIImage imageNamed:imageName];
    [self.imageView setImage:image];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
