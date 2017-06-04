//
//  MatchViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "MatchViewController.h"

@interface MatchViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *delImageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *delImageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *delImageView3;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableDictionary *imageDataDict;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 设定UI

- (void)setupNavigtion {
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = kNavigationTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"关于门当户对";
    titleLabel.frame = CGRectMake(0, 7, 50, 30);
    
    // 导航栏右侧菜单
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(0, 7, 60, 30);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    // 导航栏标题
    self.navigationItem.titleView = titleLabel;
    
    // 导航栏右侧菜单
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setupUI {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit:)]];
    
    // 添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"添加标题：";
    
    // 内容输入框
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = [UIColor blackColor];
    textView.layer.borderColor = kLineColor.CGColor;
    textView.layer.borderWidth = 1.0;
    
    // 图片上传区域
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor whiteColor];
    
    // 上传照片（最多三张，可选填）
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    subTitleLabel.textColor = [UIColor blackColor];
    subTitleLabel.text = @"上传照片（最多三张，可选填）：";
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.contentMode = UIViewContentModeCenter;
    imageView1.layer.borderColor = kLineColor.CGColor;
    imageView1.layer.borderWidth = 1.0;
    imageView1.image = [UIImage imageNamed:@"add"];
    imageView1.tag = 1;
    imageView1.userInteractionEnabled = YES;
    [imageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    UIImageView *delImageView1 = [[UIImageView alloc] init];
    delImageView1.contentMode = UIViewContentModeScaleToFill;
    delImageView1.image = [UIImage imageNamed:@"delete"];
    delImageView1.hidden = YES;
    delImageView1.tag = 11;
    delImageView1.userInteractionEnabled = YES;
    [delImageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.contentMode = UIViewContentModeCenter;
    imageView2.layer.borderColor = kLineColor.CGColor;
    imageView2.layer.borderWidth = 1.0;
    imageView2.image = [UIImage imageNamed:@"add"];
    imageView2.tag = 2;
    imageView2.userInteractionEnabled = YES;
    [imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    UIImageView *delImageView2 = [[UIImageView alloc] init];
    delImageView2.contentMode = UIViewContentModeScaleToFill;
    delImageView2.image = [UIImage imageNamed:@"delete"];
    delImageView2.hidden = YES;
    delImageView2.tag = 22;
    delImageView2.userInteractionEnabled = YES;
    [delImageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.contentMode = UIViewContentModeCenter;
    imageView3.layer.borderColor = kLineColor.CGColor;
    imageView3.layer.borderWidth = 1.0;
    imageView3.image = [UIImage imageNamed:@"add"];
    imageView3.tag = 3;
    imageView3.userInteractionEnabled = YES;
    [imageView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    UIImageView *delImageView3 = [[UIImageView alloc] init];
    delImageView3.contentMode = UIViewContentModeScaleToFill;
    delImageView3.image = [UIImage imageNamed:@"delete"];
    delImageView3.hidden = YES;
    delImageView3.tag = 33;
    delImageView3.userInteractionEnabled = YES;
    [delImageView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    [middleView addSubview:subTitleLabel];
    [middleView addSubview:imageView1];
    [middleView addSubview:delImageView1];
    [middleView addSubview:imageView2];
    [middleView addSubview:delImageView2];
    [middleView addSubview:imageView3];
    [middleView addSubview:delImageView3];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(middleView).mas_offset(20);
        make.top.mas_equalTo(middleView).mas_offset(10);
    }];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(subTitleLabel);
        make.top.mas_equalTo(subTitleLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(middleView).mas_offset(-10);
        make.height.mas_equalTo(imageView1.mas_width).multipliedBy((float)9/16);
    }];
    [delImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView1.mas_right).mas_offset(-2.5);
        make.centerY.mas_equalTo(imageView1.mas_top).mas_offset(2.5);
        make.width.height.mas_equalTo(15);
    }];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_right).mas_offset(10);
        make.top.width.height.mas_equalTo(imageView1);
    }];
    [delImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView2.mas_right).mas_offset(-2.5);
        make.centerY.mas_equalTo(imageView2.mas_top).mas_offset(2.5);
        make.width.height.mas_equalTo(15);
    }];
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView2.mas_right).mas_offset(10);
        make.top.width.height.mas_equalTo(imageView1);
        make.right.mas_equalTo(middleView).mas_offset(-20);
    }];
    [delImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView3.mas_right).mas_offset(-2.5);
        make.centerY.mas_equalTo(imageView3.mas_top).mas_offset(2.5);
        make.width.height.mas_equalTo(15);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = kLineColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = kButtonColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:textView];
    [self.view addSubview:middleView];
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(10);
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.height.mas_equalTo(120);
    }];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(textView.mas_bottom).mas_offset(20);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(-0.5);
        make.right.mas_equalTo(self.view).mas_offset(0.5);
        make.bottom.mas_equalTo(self.view).mas_offset(0.5);
        make.height.mas_equalTo(45.5);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(5);
        make.right.mas_equalTo(self.view).mas_offset(-5);
        make.bottom.mas_equalTo(self.view).mas_offset(-5);
        make.height.mas_equalTo(35);
    }];
    
    self.textView = textView;
    self.imageView1 = imageView1;
    self.imageView2 = imageView2;
    self.imageView3 = imageView3;
    self.delImageView1 = delImageView1;
    self.delImageView2 = delImageView2;
    self.delImageView3 = delImageView3;
}

#pragma mark - getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

- (NSMutableDictionary *)imageDataDict {
    if (!_imageDataDict) {
        _imageDataDict = [NSMutableDictionary dictionary];
    }
    return _imageDataDict;
}

#pragma mark - UINavigationControllerDelegate

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo  {
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        switch (self.imageIndex) {
            case 1:
                self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView1.clipsToBounds = YES;
                self.imageView1.image = image;
                self.delImageView1.hidden = NO;
                [self.imageDataDict setObject:image forKey:@"image1"];
                break;
            case 2:
                self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView2.clipsToBounds = YES;
                self.imageView2.image = image;
                self.delImageView2.hidden = NO;
                [self.imageDataDict setObject:image forKey:@"image2"];
                break;
            case 3:
                self.imageView3.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView3.clipsToBounds = YES;
                self.imageView3.image = image;
                self.delImageView3.hidden = NO;
                [self.imageDataDict setObject:image forKey:@"image3"];
                break;
            default:
                break;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - action

- (void)back:(UIButton *)button {
    
    if ([self.textView isFirstResponder]) {
        
        [self.view endEditing:YES];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEdit:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if ([self.textView isFirstResponder]) {
        
        [self.view endEditing:YES];
        return;
    }
    
    self.imageIndex = tapGestureRecognizer.view.tag;
    if (self.imageIndex < 10) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        switch (self.imageIndex) {
            case 11:
                self.imageView1.contentMode = UIViewContentModeCenter;
                self.imageView1.image = [UIImage imageNamed:@"add"];
                self.delImageView1.hidden = YES;
                [self.imageDataDict removeObjectForKey:@"image1"];
                break;
            case 22:
                self.imageView2.contentMode = UIViewContentModeCenter;
                self.imageView2.image = [UIImage imageNamed:@"add"];
                self.delImageView2.hidden = YES;
                [self.imageDataDict removeObjectForKey:@"image2"];
                break;
            case 33:
                self.imageView3.contentMode = UIViewContentModeCenter;
                self.imageView3.image = [UIImage imageNamed:@"add"];
                self.delImageView3.hidden = YES;
                [self.imageDataDict removeObjectForKey:@"image3"];
                break;
            default:
                break;
        }
    }
}

- (void)publish:(UIButton *)button {
    
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([ConversionUtil isEmpty:content] && [self.imageDataDict.allValues count] == 0) {
        return;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];
    
    UIImage *image1 = [self.imageDataDict objectForKey:@"image1"];
    UIImage *image2 = [self.imageDataDict objectForKey:@"image2"];
    UIImage *image3 = [self.imageDataDict objectForKey:@"image3"];
    
    NSString *image1Key;
    NSString *image2Key;
    NSString *image3Key;
    
    if (image1) {
        
        NSData *imageData = UIImageJPEGRepresentation(image1, 0.9);
        image1Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image1Key];
    }
    if (image2) {
        
        NSData *imageData = UIImageJPEGRepresentation(image2, 0.9);
        image2Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image2Key];
    }
    if (image3) {
        
        NSData *imageData = UIImageJPEGRepresentation(image3, 0.9);
        image3Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image3Key];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:@"moment" forKey:@"table"];
    [parameter setObject:self.userid forKey:@"userid"];
    
    if (![content isEqualToString:@""]) {
        [parameter setObject:[NSString stringWithFormat:@"%@", content] forKey:@"content"];
    }
    if (image1) {
        [parameter setObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image1Key] forKey:@"image1"];
    }
    if (image2) {
        [parameter setObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image2Key] forKey:@"image2"];
    }
    if (image3) {
        [parameter setObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image3Key] forKey:@"image3"];
    }
    
    [HttpUtil query:url parameter:parameter success:^(id responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** success %@ ***", responseDict);
        
        if ([responseDict[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD showImage:nil status:@"提交成功"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
            
            [activityIndicatorView stopAnimating];
            [activityIndicatorView removeFromSuperview];
            
            _imageDataDict = nil;
            
            self.textView.text = @"";
            
            self.imageView1.contentMode = UIViewContentModeCenter;
            self.imageView1.image = [UIImage imageNamed:@"add"];
            self.delImageView1.hidden = YES;
            
            self.imageView2.contentMode = UIViewContentModeCenter;
            self.imageView2.image = [UIImage imageNamed:@"add"];
            self.delImageView2.hidden = YES;
            
            self.imageView3.contentMode = UIViewContentModeCenter;
            self.imageView3.image = [UIImage imageNamed:@"add"];
            self.delImageView3.hidden = YES;
        } else {
            
            [activityIndicatorView stopAnimating];
            [activityIndicatorView removeFromSuperview];
            
            [SVProgressHUD showImage:nil status:@"提交失败"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        
        [SVProgressHUD showImage:nil status:@"提交失败"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.5];
    }];
}

@end
