//
//  MKViewController.m
//  3025
//
//  Created by ld on 2017/3/27.
//
//

#import "MKViewController.h"

@interface MKViewController ()

@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userid = @"1138";
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

#pragma mark - setter & getter

- (UserModel *)me {

    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
    if (userInfo) {
        _me = [UserModel mj_objectWithKeyValues:userInfo];
    } else {
        _me = nil;
        
        _me = [[UserModel alloc] init];
        _me.userid = @"1138";
    }
    
    return _me;
}

@end
