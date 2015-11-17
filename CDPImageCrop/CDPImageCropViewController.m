//
//  CDPImageCropViewController.m
//  imageCrop
//
//  Created by 柴东鹏 on 15/11/17.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import "CDPImageCropViewController.h"
#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height
#define BlackViewHeight (SHeight/2-(SWidth/4*3)/2)

@interface CDPImageCropViewController (){
    UIImageView *_imageView;
    CGRect _oldImageViewFrame;
}


@end

@implementation CDPImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBarHidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}

//初始化
-(instancetype)initWithImage:(UIImage *)image{
    if (self=[super init]) {
        _imageView=[[UIImageView alloc] initWithImage:image];
        
        [self createUI];
    }
    
    return self;
}
#pragma mark - 创建UI
-(void)createUI{
    _imageView.userInteractionEnabled=YES;
    _imageView.contentMode=UIViewContentModeScaleToFill;
    
    CGSize imageSize=_imageView.image.size;
    
    if (imageSize.width>imageSize.height) {
        NSInteger width=(SHeight-BlackViewHeight*2)/imageSize.height*imageSize.width;
        _imageView.frame=CGRectMake(0,0,width,SHeight-BlackViewHeight*2);
        
        if (width<SWidth) {
            _imageView.frame=CGRectMake(0,0,SWidth,SWidth/width*_imageView.bounds.size.height);
        }
    }
    else{
        NSInteger height=SWidth/imageSize.width*imageSize.height;
        _imageView.frame=CGRectMake(0,0,SWidth,height);
        
        if (height<SHeight-BlackViewHeight*2) {
            _imageView.frame=CGRectMake(0,0,(SHeight-BlackViewHeight*2)/height*_imageView.bounds.size.width,SHeight-BlackViewHeight*2);
        }
    }
    _imageView.center=[UIApplication sharedApplication].delegate.window.center;
    _oldImageViewFrame=_imageView.frame;
    
    [self.view addSubview:_imageView];
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SWidth,BlackViewHeight)];
    topView.backgroundColor=[UIColor blackColor];
    topView.alpha=0.7;
    topView.userInteractionEnabled=NO;
    [self.view addSubview:topView];
    
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0,SHeight-BlackViewHeight,SWidth,BlackViewHeight)];
    footView.backgroundColor=[UIColor blackColor];
    footView.alpha=0.7;
    footView.userInteractionEnabled=NO;
    [self.view addSubview:footView];
    
    [self addGestureRecognizerToImageView];
    
    [self createTopBar];
}
//imageView添加手势
-(void)addGestureRecognizerToImageView{
    //拖动
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageView:)];
    [_imageView addGestureRecognizer:panGR];
    
    //缩放
    UIPinchGestureRecognizer *pinchGR=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
    [_imageView addGestureRecognizer:pinchGR];
}
//创建导航栏
-(void)createTopBar{
    //返回
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(14,20+15,16,32)];
    [backButton setImage:[UIImage imageNamed:@"CDPImageCrop_Back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //确定
    UIButton *confirmButton=[[UIButton alloc] initWithFrame:CGRectMake(SWidth-14-32,20+20,32,22)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}
#pragma mark - 点击事件
//返回
-(void)backClick{
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(backClick)]) {
            [_delegate backClick];
        }
        else{
            NSLog(@"CDPImageCropDelegate的backClick方法未设置");
        }
    }
    else{
        NSLog(@"CDPImageCropDelegate未设置");
    }
}
//确定
-(void)confirmClick{
    UIImage *image=[self getImageFromImageView:_imageView withRect:CGRectMake(0,BlackViewHeight,SWidth,SHeight-BlackViewHeight*2)];
    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(confirmClickWithImage:)]) {
            [_delegate confirmClickWithImage:image];
        }
        else{
            NSLog(@"CDPImageCropDelegate的confirmClickWithImage:方法未设置");
        }
    }
    else{
        NSLog(@"CDPImageCropDelegate未设置");
    }
}
#pragma mark - 图片裁剪
//裁剪修改后的图片
-(UIImage *)getImageFromImageView:(UIImageView *)imageView withRect:(CGRect)rect{
    CGRect subRect=[self.view convertRect:rect toView:imageView];
    
    UIImage *changedImage=[self createChangedImageWithImageView:imageView];
    
    UIGraphicsBeginImageContext(subRect.size);
    
    [changedImage drawInRect:CGRectMake(-subRect.origin.x,-subRect.origin.y,changedImage.size.width,changedImage.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//创建修改后的图片
-(UIImage *)createChangedImageWithImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [imageView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - 手势相关
//拖动
-(void)panImageView:(UIPanGestureRecognizer *)panGR{
    CGPoint translation = [panGR translationInView:self.view];
    panGR.view.center = CGPointMake(panGR.view.center.x+translation.x,panGR.view.center.y+translation.y);
    [panGR setTranslation:CGPointZero inView:self.view];
    
    if (panGR.state==UIGestureRecognizerStateEnded) {
        [self changeFrameForGestureView:panGR.view];
    }
}
//缩放
-(void)pinchImageView:(UIPinchGestureRecognizer *)pinchGR{
    pinchGR.view.transform = CGAffineTransformScale(pinchGR.view.transform,pinchGR.scale,pinchGR.scale);
    pinchGR.scale = 1;
    
    if (pinchGR.state==UIGestureRecognizerStateEnded) {
        if (pinchGR.view.transform.a<1||pinchGR.view.transform.d<1) {
            [UIView animateWithDuration:0.25 animations:^{
                pinchGR.view.transform=CGAffineTransformIdentity;
                pinchGR.view.frame=_oldImageViewFrame;
                pinchGR.view.center=[UIApplication sharedApplication].delegate.window.center;
            }];
        }
        else{
            [self changeFrameForGestureView:pinchGR.view];
        }
    }
}
//调整手势view的frame
-(void)changeFrameForGestureView:(UIView *)view{
    CGRect frame=view.frame;
    
    if (frame.origin.x>0) {
        frame.origin.x=0;
    }
    if (frame.origin.y>BlackViewHeight) {
        frame.origin.y=BlackViewHeight;
    }
    if (CGRectGetMaxX(frame)<SWidth) {
        frame.origin.x=frame.origin.x+(SWidth-CGRectGetMaxX(frame));
    }
    if (CGRectGetMaxY(frame)<(SHeight-BlackViewHeight)) {
        frame.origin.y=frame.origin.y+(SHeight-BlackViewHeight-CGRectGetMaxY(frame));
    }
    [UIView animateWithDuration:0.25 animations:^{
        view.frame=frame;
    }];
    
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
