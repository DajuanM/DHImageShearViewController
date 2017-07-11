//
//  UIImage+DHShear.m
//  图片剪切
//
//  Created by Aiden on 16/11/10.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "UIImage+DHShear.h"

@implementation UIImage (DHShear)
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    //修改大小
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)shearImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    //获得矩形图片
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *rectImage = [UIImage imageWithCGImage:imageRef];
    return rectImage;
    //剪切成圆形图片
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    CGContextAddArc(contextRef, width/2, width/2, width/2, 0, M_PI*2, YES);
//    CGContextClip(contextRef);
//    [rectImage drawInRect:CGRectMake(0, 0, width, height)];
//    CGContextClearRect(contextRef, CGRectMake(0, 0, width, height));
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
}

- (UIImage *)createCircleImageWithRadius:(CGFloat)radius{
    UIGraphicsBeginImageContext(CGSizeMake(radius, radius));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextAddArc(contextRef, (self.size.width/2-radius), (self.size.height/2-radius), radius, 0, M_PI*2, YES);
    CGContextClip(contextRef);
    [self drawInRect:CGRectMake((self.size.width/2-radius), (self.size.height/2-radius), radius, radius)];
    CGContextClearRect(contextRef, CGRectMake((self.size.width/2-radius), (self.size.height/2-radius), radius, radius));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
