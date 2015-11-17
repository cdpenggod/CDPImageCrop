//
//  ViewController.m
//  imageCrop
//
//  Created by 柴东鹏 on 15/11/17.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import "ViewController.h"
#import "CDPImageCropViewController.h"
@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,CDPImageCropDelegate> {
    UIImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    //相册button
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50,40,100,40)];
    [button setTitle:@"进入相册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(photoAlbumClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //imageView
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-100,CGRectGetMaxY(button.frame)+14,200,150)];
    _imageView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_imageView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(_imageView.frame)+14,self.view.bounds.size.width-28,230)];
    label.backgroundColor=[UIColor whiteColor];
    label.numberOfLines=0;
    label.text=@"CDPImageCrop图片裁剪可对一张图片进行 移动缩放后裁剪 生成新的图片，并自动存入系统相册。使用只需在初始化时传入一张image即可，并不一定非要打开系统相册，demo只是个参考\n\n此外界面切换方法自定义，present或push/pop都行，demo中没有加navigationController，所以用的present方式";
    [self.view addSubview:label];
}
#pragma mark - 点击事件
-(void)photoAlbumClick{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBarHidden = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 相册回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //初始化
        CDPImageCropViewController *imageCropViewController=[[CDPImageCropViewController alloc] initWithImage:image];
        imageCropViewController.delegate=self;
        
        //如果要用push/pop方式，请自行加navigationController，demo为present方式
        [self presentViewController:imageCropViewController animated:YES completion:nil];
    }];
    
}
#pragma mark - CDPImageCropDelegate
//确定(自动将裁剪的图片存入相册)
-(void)confirmClickWithImage:(UIImage *)image{
    //如果要用push/pop方式，请自行加navigationController，demo为present方式
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //显示裁剪后的图片
    _imageView.image=image;
}
//返回
-(void)backClick{
    //如果要用push/pop方式，请自行加navigationController，demo为present方式
    [self dismissViewControllerAnimated:YES completion:nil];
}


















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
