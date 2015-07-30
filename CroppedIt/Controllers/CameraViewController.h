//
//  CameraViewController.h
//  CroppedIt
//
//  Created by GNR solution PVT.LTD on 14/04/15.
//  Copyright (c) 2015 GNR solution PVT.LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface CameraViewController : UIViewController{
    UIView *imagePreview;
    
    UIView *bottomView;
    UIButton *btnCaptureImage;
    UIButton *btnNext;
    UIButton *btnClose;
    UIImageView *capturedImageView;
    
    AVCaptureStillImageOutput *stillImageOutput;
}

@end
