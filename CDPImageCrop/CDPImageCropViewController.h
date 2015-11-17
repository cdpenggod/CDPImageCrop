//
//  CDPImageCropViewController.h
//  imageCrop
//
//  Created by 柴东鹏 on 15/11/17.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDPImageCropDelegate <NSObject>

@optional

//确定(自动将裁剪的图片存入相册)
-(void)confirmClickWithImage:(UIImage *)image;

//返回
-(void)backClick;


@end




@interface CDPImageCropViewController : UIViewController






@property (nonatomic,weak) id <CDPImageCropDelegate> delegate;



//初始化
-(instancetype)initWithImage:(UIImage *)image;












@end
