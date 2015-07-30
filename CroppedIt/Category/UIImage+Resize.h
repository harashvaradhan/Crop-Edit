//
//  Resize.h
//  CroppedIt
//
//  Created by GNR solution PVT.LTD on 14/04/15.
//  Copyright (c) 2015 GNR solution PVT.LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Resize)


+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)image;
@end
