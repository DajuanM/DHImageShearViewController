//
//  ViewController.m
//  DHImageShearViewControllerDemo
//
//  Created by swartz006 on 2017/7/11.
//  Copyright © 2017年 swartz006. All rights reserved.
//

#import "ViewController.h"
#import "DHImageShearViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width/2;
    self.imgView.layer.masksToBounds = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shearBtnClick:(id)sender {
    DHImageShearViewController *vc = [[DHImageShearViewController alloc] init];
    vc.headImage = [UIImage imageNamed:@"ChMlWVW__bqIch8cAASdcahyRvQAAINCwE5HLEABJ2J784.jpg"];
    vc.backImageBlcok = ^(UIImage *headImage) {
        self.imgView.image = headImage;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

@end
