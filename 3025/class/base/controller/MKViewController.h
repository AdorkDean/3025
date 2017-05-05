//
//  MKViewController.h
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "FMDB.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "Constant.h"
#import "UserModel.h"
#import "HttpUtil.h"
#import "DatabaseUtil.h"
#import "ConversionUtil.h"

@interface MKViewController : UIViewController

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, strong) UserModel *me;

- (BOOL)goLogin:(NSString *)title message:(NSString *)message;

@end
