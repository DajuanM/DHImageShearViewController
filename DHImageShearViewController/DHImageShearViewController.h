//
//  DHImageShearViewController.h
//  Selfjd
//
//  Created by Aiden on 16/11/11.
//  Copyright © 2016年 howe. All rights reserved.
//

//#import "DHCommonViewController.h"
//#import "DHUserModel.h"
#import <UIKit/UIKit.h>

@interface DHImageShearViewController : UIViewController
@property (nonatomic,strong ) UIImage      *headImage;
@property (nonatomic ,copy) void (^backImageBlcok)(UIImage *headImage);
@end
