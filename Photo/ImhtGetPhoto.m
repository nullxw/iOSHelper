//
//  ImhtGetPhoto.m
//  text
//
//  Created by imht-ios on 14-5-20.
//  Copyright (c) 2014年 ymht. All rights reserved.
//

#import "ImhtGetPhoto.h"

@interface ImhtGetPhoto ()

@property (nonatomic, copy) VoidBlock errorBlock;

@end


@implementation ImhtGetPhoto

- (void)dealloc
{
    DeallocLog
    self.errorBlock = nil;
}

- (id)initWithViewController:(UIViewController*)vc andError:(void (^)(void))error
{
    self = [super init];
    if (self) {
        self.errorBlock = error;
        self.viewController = vc;
        self.cutScale = 0.5;
        
    }
    return self;
}

//启动
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    UIActionSheet  * myActionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择获取图片方式"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.viewController.view];
    
}

- (void)closeMenu
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

//打开相册
- (void)showImagePicker
{    
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.allowsEditing = YES;
    [pick setDelegate:self];
    
    [self.viewController presentViewController:pick animated:YES completion:nil];
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self.viewController presentViewController:picker animated:YES completion:nil];

    }else
    {
        if (TARGET_IPHONE_SIMULATOR) {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
    }
}

#pragma mark- uiactionsheet delegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
    }
    switch (buttonIndex)
    {
    case 0:  //打开照相机拍照
        {
            if (TARGET_OS_IPHONE) {
                [self takePhoto];
            }
        break;
        }
    case 1:  //打开本地相册
        {
        [self showImagePicker];
        break;
        }
    }
}


#pragma mark- UIImagePickerController Delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    NSDictionary *postdic = [NSDictionary dictionaryWithObject:image forKey:kPhotoFinshImage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoFinshObserver object:nil userInfo:postdic];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.errorBlock) {
        self.errorBlock();
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
