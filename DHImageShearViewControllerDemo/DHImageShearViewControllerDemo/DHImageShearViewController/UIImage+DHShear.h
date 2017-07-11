//
//  UIImage+HYShear.h
//  图片剪切
//
//  Created by Aiden on 16/11/10.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYShear)
/*改变size*/
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;
/*裁切*/
- (UIImage *)shearImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
/*创建圆形图片*/
- (UIImage *)createCircleImageWithRadius:(CGFloat)radius;
@end
