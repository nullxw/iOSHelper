//
//  YtTectField.m
//  KoalaPhoto
//
//  Created by 张英堂 on 14/12/17.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import "YtTectField.h"
#import "UIColor+expanded.h"

@implementation YtTectField

- (void)awakeFromNib {
    // Initialization code
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    [view setBackgroundColor:[UIColor clearColor]];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIFont *font = [UIFont systemFontOfSize:16];
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x9B9B9B"]}];
    
    [self setAttributedPlaceholder:attributed];
}

- (void)drawPlaceholderInRect:(CGRect)rect{
    if (rect.origin.x == 0) {
        rect.size.width = rect.size.width - 10;
        rect.origin.x = rect.origin.x + 5;
    }else{
        rect.origin.x = 0;
    }
    
    [super drawPlaceholderInRect:rect];
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    [super textRectForBounds:bounds];
    
    if (self.maxTextLength != 0) {
        if (self.text.length > self.maxTextLength) {
            NSString *string = [self.text substringToIndex:self.maxTextLength];
            self.text = string;
        }
    }
    
    return bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
