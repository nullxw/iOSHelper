//
//  TYtMacro.h
//

#ifndef text_TYtMacro_h
#define text_TYtMacro_h

    #import "AFNetworking.h"
    #import "UIImageView+WebCache.h"

    //动画
    #import "ImhtAnimation.h"
    //类目
    #import "UIView+DrawLine.h"
    #import "UIColor+Mycolor.h"
    #import "UIView+Shadow.h"
    #import "MMDProHUD.h"
    #import "MMDNet.h"
//    #import "ImageCell.h"
//    #import "ImageModel.h"
    #import "BaseCell.h"
    #import "BaseModel.h"
    #import "MCFireworksButton.h"
    #import "MobClick.h"
    #import "UIImage+ytImage.h"

    #import "MBProgressHUD.h"
    #import "YTAirManageer.h"

    //屏幕宽度 （区别于viewcontroller.view.fream）
    #define WIN_WIDTH  [UIScreen mainScreen].bounds.size.width
    //屏幕高度 （区别于viewcontroller.view.fream）
    #define WIN_HEIGHT [UIScreen mainScreen].bounds.size.height

    //dealloc ARC下，输出测试使用
    #define DeallocLog  NSLog(@"%@ dealloc", NSStringFromClass([self class]));

    //IOS版本
    #define IOS_SysVersion [[UIDevice currentDevice] systemVersion].floatValue

    #define NavigationBarHight 64

    //block 宏
    typedef void(^VoidBlock)();
    typedef BOOL(^BoolBlock)();
    typedef int (^IntBlock) ();
    typedef id  (^IDBlock)  ();

    typedef void(^VoidBlock_int)(NSUInteger);
    typedef BOOL(^BoolBlock_int)(int);
    typedef int (^IntBlock_int) (int);
    typedef id  (^IDBlock_int)  (int);

    typedef void(^VoidBlock_string)(NSString*);
    typedef BOOL(^BoolBlock_string)(NSString*);
    typedef int (^IntBlock_string) (NSString*);
    typedef id  (^IDBlock_string)  (NSString*);

    typedef void(^VoidBlock_id)(id);
    typedef BOOL(^BoolBlock_id)(id);
    typedef int (^IntBlock_id) (id);
    typedef id  (^IDBlock_id)  (id);

#endif
