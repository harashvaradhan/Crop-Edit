//
//  ViewController.m
//  CroppedIt
//
//  Created by GNR solution PVT.LTD on 14/04/15.
//  Copyright (c) 2015 GNR solution PVT.LTD. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Resize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *images = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    int index = 4;
    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    bg.image = [UIImage imageNamed:@"bottle.jpg"];
    bg.image = [UIImage imageNamed:[images objectAtIndex:index]];
    [self.view addSubview:bg];

    float w = self.view.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 185, w, 400)];
    imageView.layer.borderWidth = 1.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    imageView.image = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(w, 300) withImage:[UIImage imageNamed:@"bottle.jpg"]];
    imageView.image = [UIImage imageByScalingAndCroppingForSize:CGSizeMake(w, 400) withImage:[UIImage imageNamed:[images objectAtIndex:index]]];

    [self.view addSubview:imageView];
    
    [self.view bringSubviewToFront:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
