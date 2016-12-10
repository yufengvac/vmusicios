//
//  AlphaUtil.m
//  vmusic
//
//  Created by feng yu on 16/12/10.
//  Copyright © 2016年 vac. All rights reserved.
//

#import "AlphaUtil.h"


@implementation AlphaUtil:NSObject
-(instancetype)initWithShowImageView:(UIImageView *)showImageView andHideImageView:(UIImageView *)hideImageView{
    if (self == [super init]) {
        self.showImageView = showImageView;
        self.hideImageView = hideImageView;
    }
    return self;
}
+(void)toExecuteWithShowImageView:(UIImageView*)showImageView andHideImageView:(UIImageView *)hideImageView{
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
//        __block UIImage *image = self.showImageView.image;
//        __block UIImage *image1 = self.hideImageView.image;
        for (int i =1; i<=100; i++) {
            __block CGFloat percent = i*i/(100.0*100.0);
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [showImageView setAlpha:percent];
                [hideImageView setAlpha:(1-percent)];
//                self.showImageView.image = [self imageByApplyingAlpha:percent image:image];
//                self.hideImageView.image = [self imageByApplyingAlpha:(1-percent) image:image1];
            });
            [NSThread sleepForTimeInterval:0.02];
        }
    });
}
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
