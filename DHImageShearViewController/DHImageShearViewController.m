//
//  DHImageShearViewController.m
//  Selfjd
//
//  Created by Aiden on 16/11/11.
//  Copyright © 2016年 howe. All rights reserved.
//

#import "DHImageShearViewController.h"
#import "UIImage+DHShear.h"
#import "UIImage+fixOrientation.h"
#import "Masonry.h"
//适配使用
#define AUTO_WIDTH [UIScreen mainScreen].bounds.size.width / 375.0
//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DHMaskView : UIView
@property (nonatomic,assign) CGFloat shearRadius;

@end

@implementation DHMaskView

- (void)drawRect:(CGRect)rect{
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.shearRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [[[UIColor whiteColor] colorWithAlphaComponent:0.5] setStroke];
    circlePath.lineWidth = 1;
    [circlePath stroke];
    [rectPath appendPath:circlePath];
    [rectPath setUsesEvenOddFillRule:YES];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = rectPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.2;
    [self.layer addSublayer:fillLayer];
}

- (void)setShearRadius:(CGFloat)shearRadius{
    _shearRadius = shearRadius;
}
@end

@interface DHImageShearViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic,strong ) UIImageView  *imgView;
@property (nonatomic,strong ) DHMaskView   *maskView;//遮盖层
@property (nonatomic,strong ) UIImage      *image;
@property (nonatomic,assign ) CGFloat      shearRadius;//剪切圆的半径
@property (nonatomic,strong ) UIView       *bottomView;
@property (nonatomic,strong ) UIButton     *cancelBtn;
@property (nonatomic,strong ) UIButton     *okBtn;
@end

@implementation DHImageShearViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view layoutIfNeeded];
    self.image = self.headImage;
    self.shearRadius = 100 * AUTO_WIDTH;
    [self setScrollViewZoomScale];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imgView.image = image;
    self.imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
}

- (void)setShearRadius:(CGFloat)shearRadius{
    _shearRadius = shearRadius;
    self.maskView.shearRadius = shearRadius;
    [self.scrollView setContentInset:UIEdgeInsetsMake((self.scrollView.bounds.size.height-shearRadius*2)/2,(self.scrollView.bounds.size.width-shearRadius*2)/2, (self.scrollView.bounds.size.height-shearRadius*2)/2, (self.scrollView.bounds.size.width-shearRadius*2)/2)];
}

- (void)setScrollViewZoomScale{
    CGFloat minScale,maxScale;
    CGFloat scaleWidth = self.shearRadius*2/self.image.size.width;
    CGFloat scaleHeight = self.shearRadius*2/self.image.size.height;
    minScale = MAX(scaleWidth, scaleHeight);
    //设置最多缩放比例
    maxScale = 1.0f;
    [self.scrollView setMinimumZoomScale:minScale];
    [self.scrollView setMaximumZoomScale:maxScale];
    //缩放图片让图片能全部显示在屏幕上
    CGFloat scaleW = self.scrollView.bounds.size.width/self.image.size.width;
    CGFloat scaleH = self.scrollView.bounds.size.height/self.image.size.height;
    [self.scrollView setZoomScale:scaleW<scaleH?scaleW:scaleH];
    //使图片显示在中间
    [self.scrollView setContentOffset:CGPointMake(-(self.scrollView.bounds.size.width-self.image.size.width*self.scrollView.zoomScale)/4, -(self.scrollView.bounds.size.height-self.image.size.height*self.scrollView.zoomScale)/2)];
}
#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

#pragma mark - btn click
- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okBtnClick{
    CGFloat zoomScale = self.scrollView.zoomScale;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat zoomScaleX = (self.scrollView.contentInset.left+offsetX)/zoomScale;
    CGFloat zoomScaleY = (self.scrollView.contentInset.top+offsetY)/zoomScale;
    CGFloat width = MAX(self.shearRadius*2/zoomScale, self.shearRadius*2);
    //如果zoomScale大于1.0需进行如下判断
    if (zoomScale >= 1) {
        width = self.shearRadius*2/zoomScale;
    }else{
        width = MAX(self.shearRadius*2/zoomScale, self.shearRadius*2);
    }
    UIImage *image = [self.imgView.image shearImageWithX:zoomScaleX y:zoomScaleY width:width height:width];
    image = [image resizeToWidth:self.shearRadius*2 height:self.shearRadius*2];
    
    self.backImageBlcok(image);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, (74)*AUTO_WIDTH, 0));
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, (74)*AUTO_WIDTH, 0));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(74*AUTO_WIDTH);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15*AUTO_WIDTH);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15*AUTO_WIDTH);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
}

#pragma mark - lazy loading
- (UIScrollView *)scrollView {
	if(_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
	}
	return _scrollView;
}

- (UIImageView *)imgView {
	if(_imgView == nil) {
		_imgView = [[UIImageView alloc] init];
        [self.scrollView addSubview:_imgView];
	}
	return _imgView;
}

- (DHMaskView *)maskView {
	if(_maskView == nil) {
		_maskView = [[DHMaskView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = NO;
        [self.view addSubview:_maskView];
	}
	return _maskView;
}
- (UIView *)bottomView {
	if(_bottomView == nil) {
		_bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColorFromRGB(0x141414);
        [self.view addSubview:_bottomView];
	}
	return _bottomView;
}

- (UIButton *)cancelBtn {
	if(_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_cancelBtn];
	}
	return _cancelBtn;
}

- (UIButton *)okBtn {
	if(_okBtn == nil) {
		_okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_okBtn setTitleColor:UIColorFromRGB(0x1acefd) forState:UIControlStateNormal];
        [_okBtn setTitle:@"选取" forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_okBtn];
	}
	return _okBtn;
}
@end
