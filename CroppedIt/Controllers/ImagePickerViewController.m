//
//  ImagePickerViewController.m
//  CroppedIt
//
//  Created by Harshavardhan Edke on 12/22/15.
//  Copyright © 2015 GNR solution PVT.LTD. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController (){
  UIImagePickerController *pickerCont;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - on Camera Button 
- (IBAction)onCamera:(id)sender {
  
  pickerCont = [[UIImagePickerController alloc]init];
  pickerCont.allowsEditing = YES;
  pickerCont.sourceType = UIImagePickerControllerSourceTypeCamera;
  pickerCont.delegate = self;
  [self presentViewController:pickerCont animated:YES completion:nil];
}



#pragma mark - UIImagePickerDelegate

// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
//  
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  NSLog(@"imagePickerController didFinishPickingMediaWithInfo");
  self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  [pickerCont dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  NSLog(@"imagePickerControllerDidCancel");
  [pickerCont dismissViewControllerAnimated:YES completion:nil];
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
