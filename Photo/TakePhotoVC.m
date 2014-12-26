//
//  TakePhotoVC.m
//  KoalaPhoto
//
//  Created by 张英堂 on 14/11/13.
//  Copyright (c) 2014年 visionhacker. All rights reserved.
//

#import "TakePhotoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "CheckPhotoVC.h"
#import "YTMacro.h"
#import "FileManage.h"
#import "UIImage+Resize.h"

@interface TakePhotoVC ()

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIButton *shutterButton;//拍照按钮

@property (nonatomic, strong) UIImage *kakaImage;
@end

@implementation TakePhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initialSession];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.title = @"拍照";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUpCameraLayer];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化相机
- (void) initialSession
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用后摄像头，所以这么写，具体的实现方法后面会介绍
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

//前后摄像头
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//加载图层预览
- (void) setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        CALayer * viewLayer = [self.view layer];
        
        [self.previewLayer setFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    }
}

//拍照
- (IBAction)shutterCamera:(id)sender
{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        CGSize size = CGSizeMake(WIN_WIDTH, WIN_HEIGHT);
        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        UIImage *croppedImage = [scaledImage croppedImage:self.previewLayer.frame];
        
        self.kakaImage = croppedImage;
        [self pushCheckVC:nil];
        
    }];
}


- (void)pushCheckVC:(id)sender{
    CheckPhotoVC *check = [[CheckPhotoVC alloc] initWithNibName:@"CheckPhotoVC" bundle:nil];
    check.personImage = self.kakaImage;
    check.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:check];
    
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

//前后摄像头的切换
- (void)toggleCamera:(id)sender{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
