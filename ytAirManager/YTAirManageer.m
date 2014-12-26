//
//  AirManageer.m
//  AirTest
//
//  Created by megvii on 14-8-14.
//  Copyright (c) 2014年 megvii. All rights reserved.
//

#import "YTAirManageer.h"

//屏幕宽度 （区别于viewcontroller.view.fream）
#define AIRWIN_WIDTH  [UIScreen mainScreen].bounds.size.width
//屏幕高度 （区别于viewcontroller.view.fream）
#define AIRWIN_HEIGHT [UIScreen mainScreen].bounds.size.height
//IOS版本
#define AIRIOS_SysVersion [[UIDevice currentDevice] systemVersion].floatValue


@interface YTAirManageer ()

//菜单所属的VC
@property (strong, nonatomic) UIViewController *menuViewController;

//正页面所属的VC
@property (strong, nonatomic) UIViewController *airViewController;


//点击 air界面就收起 抽屉 手势
@property (strong, nonatomic) UITapGestureRecognizer *closeMenuGest;

@end

@implementation YTAirManageer

-(void)dealloc
{
    _menuShowimgBlock = nil;
    _menuHidimgBlock = nil;
    _menuWillShowBLock = nil;
    _menuWillHideBLock = nil;
    _menuDidShowBLock = nil;
    _menuDidHideBLock = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.menuViewController.view];
    [self.view addSubview:self.airViewController.view];
    
    CGRect mainRect = self.view.frame;
    if (AIRIOS_SysVersion < 7) {
        [self.airViewController.view setFrame:CGRectMake(0, 0, AIRWIN_WIDTH, mainRect.size.height)];
        [self.menuViewController.view setFrame:CGRectMake(0, 0, AIRWIN_WIDTH, mainRect.size.height)];
    }else{
        [self.airViewController.view setFrame:mainRect];
        [self.menuViewController.view setFrame:mainRect];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(instancetype)shareAirManager
{
   static YTAirManageer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YTAirManageer alloc] init];
    });
    return manager;
}

- (void)setAirViewController:(UIViewController *)airViewController
       andMenuViewController:(UIViewController *)menuVC
{
    self.airViewController = airViewController;
    self.menuViewController = menuVC;
    [self addChildViewController:airViewController];
    [self addChildViewController:menuVC];
}


//更改airviewcontroller
- (void)chageAirViewController:(UIViewController *)viewController animation:(BOOL)animation
{
    if (![self checkOldAirVCAndNewVC:viewController]) {
        
        BOOL isRotate = [self isShowMenu];
        if (self.airViewController.view.superview == self.view) {
            [self.airViewController.view removeFromSuperview];
        }
        if ([self.airViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)self.airViewController;
            navi.viewControllers = nil;
        }
        
        self.airViewController = nil;
        self.airViewController = viewController;
        
        CGRect mainRect = self.view.frame;
        if (AIRIOS_SysVersion < 7) {
            [self.airViewController.view setFrame:CGRectMake(0, 0, AIRWIN_WIDTH, mainRect.size.height)];
        }else{
            [self.airViewController.view setFrame:mainRect];
        }
        //是否开启了动画
        if (animation == YES) {
            if (isRotate == YES) {
                [self rotateLater];
            }
        }
        [self.view addSubview:self.airViewController.view];
    }
}

//当更改airVC 时检查新的与旧的是否相同，
- (BOOL)checkOldAirVCAndNewVC:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[self.airViewController class]]) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *newNavi = (UINavigationController *)viewController;
            UIViewController *newVC = newNavi.viewControllers.firstObject;
            
            UINavigationController *oldNavi = (UINavigationController *)self.airViewController;
            UIViewController *oldVC = oldNavi.viewControllers.firstObject;
            
            if ([newVC isKindOfClass:[oldVC class]]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return YES;
        }
    }
    return NO;
}


- (BOOL)isShowMenu
{
    return !CATransform3DIsIdentity(self.airViewController.view.layer.transform);
}


//检查所有VC的view是否在该页面上
- (void)checkAllVCView
{
    if (self.airViewController.view.superview != self.view) {
        [self.view addSubview:self.airViewController.view];
        [self.airViewController.view setFrame:self.view.bounds];
    }
    if (self.menuViewController.view.superview != self.view) {
        [self.view addSubview:self.menuViewController.view];
        [self.menuViewController.view setFrame:self.view.bounds];
    }
}



//显示/隐藏 菜单栏
- (BOOL)showMenu
{
    if ([self checkSet]) {
        [self checkAllVCView];
        BOOL isscral = CATransform3DIsIdentity(self.airViewController.view.layer.transform);
        
        if (isscral) {
            if (self.closeMenuGest == nil) {
                self.closeMenuGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
            }
            [self.airViewController.view addGestureRecognizer:self.closeMenuGest];

            if ([self.airViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *airNavi = (UINavigationController *)self.airViewController;
                [airNavi.visibleViewController.view setUserInteractionEnabled:NO];
            }else{
                [self.airViewController.view setUserInteractionEnabled:NO];
            }
            if (self.menuWillShowBLock) {
                self.menuWillShowBLock();
            }
            [UIView animateWithDuration:0.4
                             animations:^(){
                                 if (self.menuShowimgBlock) {
                                     self.menuShowimgBlock();
                                 }
                                 [self rotateLater];
                             } completion:^(BOOL finished) {
                                 if (self.menuDidShowBLock) {
                                     self.menuDidShowBLock();
                                 }
                             }];
        }else{
            [self.airViewController.view removeGestureRecognizer:self.closeMenuGest];
            
            if ([self.airViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *airNavi = (UINavigationController *)self.airViewController;
                [airNavi.visibleViewController.view setUserInteractionEnabled:YES];
            }else{
                [self.airViewController.view setUserInteractionEnabled:YES];
            }
            if (self.menuWillHideBLock) {
                self.menuWillHideBLock();
            }
            [UIView animateWithDuration:0.3
                             animations:^(){
                                 if (self.menuHidimgBlock) {
                                     self.menuHidimgBlock();
                                 }
                                 [self rotateBefore];
                             }];
        }
        return  YES;
    }
    return NO;
}

//airview 旋转之后的状态 --- 动画再次修改
- (void)rotateLater
{
    CATransform3D layerTrans = CATransform3DMakeScale(0.7, 0.7, 1);
    layerTrans.m34 = 1.0 / 1000;
    
    layerTrans = CATransform3DTranslate(layerTrans, AIRWIN_WIDTH * 0.9 , 0, 0);
    layerTrans = CATransform3DRotate(layerTrans, 0.5 * M_PI_2, 0.0f, 1.0f, 0.0f);
    self.airViewController.view.layer.zPosition = 100;
    self.airViewController.view.layer.transform = layerTrans;
}

//airview 旋转之前
- (void)rotateBefore
{
    self.airViewController.view.layer.transform = CATransform3DIdentity;
}


//检查设置
- (BOOL)checkSet
{
    if (!self.airViewController || !self.menuViewController) {
        return NO;
    }
    return YES;
}

//开启手势，并且检查以前是否存在清扫手势，如果存在，不进行处理
- (void)openGest
{
    NSInteger *gestNum = 0;
    for (UIGestureRecognizer *gest in self.view.gestureRecognizers) {
        if ([gest isKindOfClass:[UISwipeGestureRecognizer class]]) {
            gestNum++;
        }
    }
    if (gestNum == 0) {
        UISwipeGestureRecognizer *RightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHanle:)];
        RightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        UISwipeGestureRecognizer *LeftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHanle:)];
        LeftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        
//        [self.airViewController.view addGestureRecognizer:RightSwipe];
        
        [self.view addGestureRecognizer:LeftSwipe];
    }
}

- (void)closeGest
{
    for (UIGestureRecognizer *gest in self.view.gestureRecognizers) {
        if ([gest isKindOfClass:[UISwipeGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gest];
        }
    }
}

- (void)swipeHanle:(UISwipeGestureRecognizer *)sender
{
    if ([self isShowMenu] == NO && sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showMenu];
    }
    if ([self isShowMenu] == YES && sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showMenu];
    }
}


- (UIViewController*)getAirViewController
{
    UIViewController *airVC = nil;
    if ([self.airViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)self.airViewController;
        airVC = navi.viewControllers.firstObject;
    }else{
        airVC = self.airViewController;
    }
    return airVC;
}

- (BOOL)compareViewController:(Class)mmdclass
{
    UIViewController *vc = [self getAirViewController];
    if ([vc isKindOfClass:[mmdclass class]]) {
        return YES;
    }
    return NO;
}





@end







