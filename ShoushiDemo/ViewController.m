//
//  ViewController.m
//  ShoushiDemo
//
//  Created by 贾金达 on 2020/7/20.
//  Copyright © 2020 jiajinda. All rights reserved.
//

#import "ViewController.h"
#import "Toast.h"
@interface ViewController ()<UIGestureRecognizerDelegate>
@property UIImage *image;
@property UIImageView *imageView;
@property CGFloat imageWidth;
@property CGFloat imageHeight;
@property CGFloat presentScale;
@property CGPoint presentCenterPosition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createImage];
    [self createRecognizer];
}
- (void)createImage{
    self.presentScale = 1;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = self.view.bounds;
    self.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"]]];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    NSLog(@"%f",self.view.frame.origin.x);
    NSLog(@"%f",self.imageView.frame.origin.y);
    self.imageWidth = self.imageView.frame.size.width;
    self.imageHeight = self.imageView.frame.size.height;
    self.presentCenterPosition = CGPointMake(self.imageView.frame.size.width/2, self.imageView.frame.size.height/2);
}
- (void)createRecognizer{
// 创建缩放手势识别对象实例和初始化
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(pinchGesture:)];
    pinchRecognizer.delegate = self;
    // 绑定到指定视图来响应手势
    [self.imageView addGestureRecognizer:pinchRecognizer];
    
// 创建一个单击手势
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(singleTapGesture:)];
 


    // 视图添加tap点击事件
    [self.view addGestureRecognizer:tapRecognizer];
    [self.imageView setUserInteractionEnabled:YES];

// 创建一个双击放大的手势
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(doubleTapGesture)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapRecognizer];
    [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
//创建一个平移手势
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        [self.imageView addGestureRecognizer:panRecognizer];
    [tapRecognizer requireGestureRecognizerToFail:panRecognizer];
    
//创建一个长按手势
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.imageView addGestureRecognizer:longPressRecognizer];
    [tapRecognizer requireGestureRecognizerToFail:longPressRecognizer];
}
// 响应事件，输出缩放比例的大小数值
- (void) pinchGesture:(UIPinchGestureRecognizer*) sender {
    NSLog(@"AAA");
    self.presentScale = sender.scale;
    CGRect frame = self.imageView.frame;
    frame.size.width = self.imageWidth*self.presentScale;
    frame.size.height = self.imageHeight*self.presentScale;
    self.imageView.frame = frame;

    self.imageView.center = self.presentCenterPosition;
    
    
}
- (void)singleTapGesture:(UITapGestureRecognizer*) sender{
       CGPoint poisition = [sender locationInView:self.view];
    [self.view makeToast:[NSString stringWithFormat:@"x:%.2f y:%.2f",poisition.x,poisition.y] duration:1 position:CSToastPositionTop];
    NSLog(@"This is a picture!");
}
- (void)doubleTapGesture{
    self.presentScale*=1.5;
    CGRect frame = self.imageView.frame;
    frame.size.width = self.imageWidth*self.presentScale;
    frame.size.height = self.imageHeight*self.presentScale;
    frame.origin = self.presentCenterPosition;
    self.imageView.frame = frame;
    
    self.imageView.center = self.presentCenterPosition;
}
- (void)panGesture:(UIPanGestureRecognizer*)sender{
    CGPoint poisition = [sender translationInView:self.view];
    NSLog(@"x:%.2f y:%.2f",poisition.x,poisition.y);
    self.presentCenterPosition = CGPointMake(poisition.x+self.imageView.center.x, poisition.y+self.imageView.center.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.imageView];
    
    self.imageView.center = self.presentCenterPosition;
    
}
- (void)longPressGesture:(UILongPressGestureRecognizer*)sender{


    
    if (UIGestureRecognizerStateBegan ==sender.state) {
        UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
        [impactLight impactOccurred];
        

        CGPoint poisition = [sender locationInView:self.view];
        NSLog(@"%.2f %.2f",poisition.x,poisition.y);
     }


}
@end
