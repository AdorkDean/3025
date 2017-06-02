//
//  ImageBrowser.m
//  3025
//
//  Created by ld on 2017/6/2.
//
//

#import "ImageBrowser.h"
#import "Constant.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface ImageBrowser () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation ImageBrowser

+ (ImageBrowser *)sharedImageBrowser {
    
    static dispatch_once_t predicate;
    static ImageBrowser *sharedImageBrowser;
    
    dispatch_once(&predicate, ^{
        sharedImageBrowser = [[ImageBrowser alloc] init];
    });
    
    return sharedImageBrowser;
}

+ (void)show:(NSArray *)imageList currentIndex:(NSUInteger)index {
    
    // 背景视图
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    
    // 滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(kScreenWidth * imageList.count, kScreenHeight);
    scrollView.delegate = [ImageBrowser sharedImageBrowser];
    
    // 图片视图
    UIImageView *tmpImageView;
    for (NSString *imageUrl in imageList) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:[ImageBrowser sharedImageBrowser] action:@selector(close)]];
        
        [scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tmpImageView ? tmpImageView.mas_right : scrollView);
            make.top.width.height.mas_equalTo(scrollView);
        }];
        
        tmpImageView = imageView;
    }
    
    // 当前图片
    scrollView.contentOffset = CGPointMake(kScreenWidth * index, 0);
    
    // 分页视图
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.numberOfPages = imageList.count;
    pageControl.currentPage = index;
    [ImageBrowser sharedImageBrowser].pageControl = pageControl;
    
    [backgroundView addSubview:scrollView];
    [backgroundView addSubview:pageControl];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(backgroundView);
    }];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backgroundView);
        make.bottom.mas_equalTo(backgroundView).mas_offset(-20);
    }];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        keyWindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    [keyWindow addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(keyWindow);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        backgroundView.alpha = 1.0;
    }];

    [ImageBrowser sharedImageBrowser].backgroundView = backgroundView;
}

- (void)close {

    [UIView animateWithDuration:0.25 animations:^{
        [ImageBrowser sharedImageBrowser].backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[ImageBrowser sharedImageBrowser].backgroundView removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint contentOffset = scrollView.contentOffset;
    [ImageBrowser sharedImageBrowser].pageControl.currentPage = contentOffset.x / kScreenWidth;
}

@end
