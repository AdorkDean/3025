//
//  ImageBrowser.h
//  3025
//
//  Created by ld on 2017/6/2.
//
//

#import <UIKit/UIKit.h>

@interface ImageBrowser : UIView

+ (ImageBrowser *)sharedImageBrowser;
+ (void)show:(NSArray *)imageList currentIndex:(NSUInteger)index;

@end
