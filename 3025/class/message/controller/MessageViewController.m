//
//  MessageViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setAutoresizesSubviews:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    
    [self setupNavigtion];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI

/**
 *  设定UI
 */
- (void)setupUI {
    
}

- (void)setupNavigtion {
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"消息";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);

    self.navigationItem.titleView = titleLabel;
}

@end
