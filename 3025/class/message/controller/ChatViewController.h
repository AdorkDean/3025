//
//  ChatViewController.h
//  3025
//
//  Created by WangErdong on 2017/6/3.
//
//

#import <UIKit/UIKit.h>
#import "MKViewController.h"

@interface ChatViewController : MKViewController

@property (nonatomic, copy) NSString *withUserid;
@property (nonatomic, copy) NSString *withUsername;
@property (nonatomic, copy) NSString *me_poster;
@property (nonatomic, copy) NSString *other_poster;

@end
