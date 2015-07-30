//
//  CameraViewController.m
//  CroppedIt
//
//  Created by GNR solution PVT.LTD on 14/04/15.
//  Copyright (c) 2015 GNR solution PVT.LTD. All rights reserved.
//

#import "CameraViewController.h"
#import "UIImage+Resize.h"

#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)

#define BLACK_ALPHA_COLOR       [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8]
#define GREEN_COLOR             [UIColor colorWithRed:115.0/255.0 green:140.0/255.0 blue:41.0/255.0 alpha:1]
#define BLUE_COLOR              [UIColor colorWithRed:27.0/255.0 green:154.0/255.0 blue:247.0/255.0 alpha:1]
#define WHITE_COLOR             [UIColor whiteColor]
#define BLACK_COLOR             [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]
#define LIGHT_GRAY_COLOR        [UIColor lightGrayColor]
#define GRAY_COLOR              [UIColor grayColor]
#define CLEAR_COLOR             [UIColor colorWithRed:0 green:0 blue:0 alpha:0]
#define CUSTOM_GRAY_COLOR       [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1]


@interface CameraViewController ()
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imagePreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:imagePreview];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    bottomView.backgroundColor = CLEAR_COLOR;
    
    btnCaptureImage = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 30, 5, 60, 60)];
    [btnCaptureImage setBackgroundColor:GREEN_COLOR];
    [btnCaptureImage addTarget:self action:@selector(onCaptureImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    btnCaptureImage.layer.cornerRadius = 30;
    btnCaptureImage.layer.borderColor = WHITE_COLOR.CGColor;
    btnCaptureImage.layer.borderWidth = 4.0;
    
    btnNext = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 80, 30)];
    btnNext.backgroundColor = BLUE_COLOR;
    [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    btnNext.hidden = YES;
    [btnNext addTarget:self action:@selector(onNextPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:btnCaptureImage];
    [bottomView addSubview:btnNext];
    
    btnClose = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 40, 44, 44)];
//    [btnClose setImage:[UIImage imageForDeviceWithName:@"close"]forState:UIControlStateNormal];
    btnClose.backgroundColor = GREEN_COLOR;
    [btnClose addTarget:self action:@selector(onCloseCameraPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose bringSubviewToFront:self.view];
    [self.view addSubview:btnClose];
    [self.view addSubview:bottomView];
    //end of overlay view fro Camera
    
    //View for captured image
    capturedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:capturedImageView];
    capturedImageView.hidden = YES;
    //end of captured image view

    ///Capture Session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect layerRect = [[[self view] layer] bounds];
    
    layerRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    captureVideoPreviewLayer.frame = layerRect;
    [captureVideoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    [imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    [session startRunning];
}

-(void)onCaptureImagePressed:(UIButton *)button{
    NSLog(@"Camera Button pressed");
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         capturedImageView.image = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) withImage:image];
         [self updateViews];
     }];
}

-(void)onNextPressed:(UIButton *)button{
    NSLog(@"Next Button pressed");
}

-(void)onCloseCameraPressed:(UIButton *)button{
    NSLog(@"Close Button pressed");
    if (btnNext.hidden == NO) {
        capturedImageView.hidden = YES;
        btnCaptureImage.userInteractionEnabled = YES;
        btnNext.hidden = YES;
    }else{
        
    }
}

-(void)updateViews{
    capturedImageView.hidden = NO;
    [capturedImageView bringSubviewToFront:self.view];
    [self.view bringSubviewToFront:bottomView];
    [self.view bringSubviewToFront:btnClose];
    btnNext.hidden = NO;
    btnCaptureImage.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
