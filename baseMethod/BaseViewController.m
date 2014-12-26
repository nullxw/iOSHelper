//
//  BaseViewController.m
//  text
//
//  Created by imht-ios on 14-4-18.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationItem+ImhtNavi.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@property (strong, nonatomic) MBProgressHUD *progressView;

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view.
    
//    /** IOS7 适配使用 */
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
    
//    /** IOS 7 以后的navigationitem 自动对图片，背景色进行处理，该方法为了取消自动处理 */
    self.navigationController.navigationBar.translucent = NO;

    
}

- (void)setNaviTitle:(NSString *)title
{
    [self addNavigationTitle:title withFont:[UIFont systemFontOfSize:20] withColor:[UIColor whiteColor]];
}

- (void)checkNetStatus
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//title字体太亮问题
- (void)addNavigationTitle:(NSString *)title withFont:(UIFont *)font withColor:(UIColor *)color
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setText:title];
    [lable setFont:font];
    [lable setTextColor:color];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:lable];
}

- (void)addDownColor:(UIColor *)color tag:(id)tag action:(SEL)action{
    UIBarButtonItem *baritme = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:tag action:action];
    [baritme setTintColor:color];
    [self.navigationItem setRightBarButtonItem:baritme];
}

- (void)addBackGest
{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backNextVC:)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swip];
    
}


//添加返回键，子类调用即可
- (void)addBackNaviItem
{
    [self.navigationItem addBackItemTarget:self action:@selector(backNextVC:)];
}

//返回事件
- (void)backNextVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addMenuShowBTN:(id)sender
{
//    [self.navigationItem addLeftItemTarget:self action:@selector(menuShow:) andImage:[UIImage imageNamed:@"btn_menu"] andSize:CGSizeMake(-10, 0)];
}

- (void)menuShow:(id)sender
{
//    [[YTAirManageer shareAirManager] showMenu];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)alertWithWithTitle:(NSString *)title message:(NSString *)message  cancelButtonTitle:(NSString *)cancel
{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alerView show];
}

/**
 *  启动屏幕大菊花
 *
 *  @param text  大菊花上的字
 *  @param image 大菊花的背景（两者只能有一个）
 */
- (void)starMumWithTitle:(NSString *)text
                topImage:(UIImage *)image
{
    if (!self.progressView) {
        self.progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.progressView setAnimationType:MBProgressHUDAnimationZoomIn];

    }
    if (image) {
        [self.progressView setMode:MBProgressHUDModeCustomView];
    }else
    {
        [self.progressView setMode:MBProgressHUDModeIndeterminate];
    }
    
    [self.progressView setLabelText:text];
    if ([self.progressView removeFromSuperViewOnHide]) {
        [self.progressView show:YES];
    }
}

/**
 *  停止动画
 */
- (void)stopMumWithAfterDelay:(NSTimeInterval)delay
{
    if (! self.progressView) {
        [[NSException exceptionWithName:@"逗我玩么？" reason:@"CNM， 动画就没启动过" userInfo:nil] raise];
    }
    [self.progressView setAnimationType:MBProgressHUDAnimationZoomOut];
    
    if (delay == 0) {
        [self.progressView hide:YES afterDelay:0.1f];
    }else
    {
        [self.progressView hide:YES afterDelay:delay];
    }
}

/**
 *  回收键盘
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end





