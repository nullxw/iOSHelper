//
//  APPUpdateManager.m
//  KoalaPerson
//
//  Created by 张英堂 on 14/12/18.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import "APPUpdateManager.h"
#import "KKNet.h"

@implementation APPUpdateManager

static APPUpdateManager *app;

+ (instancetype)checkUpdate{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        app = [[APPUpdateManager alloc] init];
    });
    
    return app;
}


- (void)check{
    
    [self performSelector:@selector(checkAndUpdate) withObject:nil afterDelay:5];

}

- (void)checkAndUpdate{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // app build版本
    //    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSArray *array = [app_Version componentsSeparatedByString:@"."];
    NSUInteger nowVersion = [array[0] integerValue] * 100000 + [array[1] integerValue] * 1000 + [array[2] integerValue] * 1;
    
    [[KKNet shareManager] getUpdateString:^(id XXX) {
        NSString *netVersion = XXX;
        
        NSArray *newArray = [netVersion componentsSeparatedByString:@"."];
        NSUInteger newVersion = [newArray[0] integerValue] * 100000 + [newArray[1] integerValue] * 1000 + [newArray[2] integerValue] * 1;
        
        if (newVersion > nowVersion) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"APP有新版本需要更新" delegate:self cancelButtonTitle:@"取消更新" otherButtonTitles:@"确定更新", nil];
            [alertView setDelegate:self];
            [alertView show];
        }
    }];
    
}

#pragma mark -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services:///?action=download-manifest&url=https://koalacam.net/static/otherfiles/KoalaPhoto.plist"]];
        exit(0);
    }
}
@end
