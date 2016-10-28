//
//  XTWebView.m
//  XTWebView
//
//  Created by TuTu on 16/10/28.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "XTWebView.h"
#import "UIImage+Add.h"

#define APPFRAME                        [UIScreen mainScreen].bounds
#define APP_WIDTH                       APPFRAME.size.width
#define kHeaderHeight                   (float)(APP_WIDTH * 3.0 / 4.0)

CG_INLINE CGRect
CGRectSetY(CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    return rect;
}


@interface XTWebView ()
@property (nonatomic,strong)UIView *header;
@property (nonatomic,strong)UIView *zqBrowserView;
@property (nonatomic, strong) NSMutableArray *blurImages;
@end

@implementation XTWebView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _zqBrowserView = [self.scrollView.subviews lastObject];
        self.header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, kHeaderHeight)];
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

//set header
- (void)setHeader:(UIView *)header
{
    if (_header) {
        [_header removeFromSuperview];
        _header = nil;
    }
    _header = header;
    [self.scrollView addSubview:header];
    _zqBrowserView.frame = CGRectSetY(_zqBrowserView.frame, CGRectGetMaxY(header.frame));
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, kHeaderHeight)] ;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageNamed:@"header"] ;
    [_header addSubview:self.headerImageView] ;
    self.blurImages = [[NSMutableArray alloc] init] ;
    [self prepareForBlurImages] ;
    _header.clipsToBounds = YES;
    
}



- (void)prepareForBlurImages
{
    if (self.headerImageView.image == nil) {
        return ;
    }
    [self.blurImages addObject:self.headerImageView.image];

    for (int i = 1; i <= 9; i++) {
        float rate = i * 0.1 ;
        [self.blurImages addObject:[self.headerImageView.image boxblurImageWithBlur:rate]];
    }
}


- (void)blurWithOffset:(float)offset
{
    NSInteger index = offset / 10;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.blurImages.count) {
        index = self.blurImages.count - 1;
    }
    UIImage *image = self.blurImages[index];
    if (self.headerImageView.image != image) {
        [self.headerImageView setImage:image];
    }
}



- (void) dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = self.scrollView.contentOffset.y;
        [self animationForScroll:offset];
    }
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context] ;
    }
    
}


- (void)animationForScroll:(CGFloat) offset
{
//    NSLog(@"offsety %@",@(offset)) ;
    CATransform3D headerTransform = CATransform3DIdentity;
    // DOWN -----------------
    if (offset < 0) {
        CGFloat headerScaleFactor = -(offset) / self.header.bounds.size.height;
        CGFloat headerSizevariation = ((self.header.bounds.size.height * (1.0 + headerScaleFactor)) - self.header.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, -headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        self.header.layer.transform = headerTransform;
    }
    // SCROLL UP/DOWN ------------
    else {
//        if (offset > (kHeaderHeight - 68.)) {
////            [self.xtDelegate displayNavigationBar:YES] ;
//        }
//        else {
////            [self.xtDelegate displayNavigationBar:NO] ;
//        }
    }
    
    // blur
    if (self.headerImageView.image != nil) {
        [self blurWithOffset:offset];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
