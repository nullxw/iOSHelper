//
//  SCCaptureSessionManager.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCDefines.h"

#define MAX_PINCH_SCALE_NUM   3.f
#define MIN_PINCH_SCALE_NUM   1.f

@protocol YTCaptureSessionManager;

typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);

@interface YTCaptureSessionManager : NSObject

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

//pinch
@property (nonatomic, assign) CGFloat preScaleNum;
@property (nonatomic, assign) CGFloat scaleNum;


@property (nonatomic, assign) id <YTCaptureSessionManager> delegate;


//加入到 view 中
- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect;

//拍照
- (void)takePicture:(DidCapturePhotoBlock)block;

- (void)switchCamera:(BOOL)isFrontCamera;

- (void)pinchCameraViewWithScalNum:(CGFloat)scale;

- (void)pinchCameraView:(UIPinchGestureRecognizer*)gesture;

- (void)switchFlashMode:(UIButton*)sender;

- (void)focusInPoint:(CGPoint)devicePoint;

- (void)switchGrid:(BOOL)toShow;

@end


@protocol YTCaptureSessionManager <NSObject>

@optional
- (void)didCapturePhoto:(UIImage*)stillImage;

@end
