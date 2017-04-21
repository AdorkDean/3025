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

    if (!_me) {
    
        _me = [[UserModel alloc] init];
        _me.userid = @"1138";
        _me.poster = @"http://www.viewatmobile.cn/3025/pages/upload/1138/poster_1486449253075.jpg";
        _me.nickname = @"风满楼2017";
        _me.unitNature = @"NEC";
        _me.position = @"高级经理";
    }
    
    return _me;
}

@end
