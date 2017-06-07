//
//  TruthViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "TruthViewController.h"
#import "ImageBrowser.h"

@interface TruthViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *delImageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *delImageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *delImageView3;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableDictionary *imageDataDict;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *noticeList;

@end

@implementation TruthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
    [self loadData];
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
    titleLabel.text = @"真实性验证";
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    float height = 0;

    UIScrollView *scrollView = self.view.subviews.firstObject;
    UIView *add1View = scrollView.subviews[0];
    UIView *add2View = scrollView.subviews[1];
    UIView *add3View = scrollView.subviews[2];
    
    CGSize size = [add1View sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    height += size.height;
    
    size = [add2View sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    height += size.height;

    size = [add3View sizeThatFits:CGSizeMake(kScreenWidth, MAXFLOAT)];
    height += size.height;
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, height + 64);
}

- (void)setupUI {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:kBackgroundColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit:)]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = kBackgroundColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounds = self.view.bounds;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = kLineColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = kButtonColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:scrollView];
    [self.view addSubview:bottomView];
    [self.view addSubview:button];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
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
    
    UIView *add1View = [self imageAddView:0];
    UIView *add2View = [self imageAddView:1];
    UIView *add3View = [self imageAddView:2];
    
    [scrollView addSubview:add1View];
    [scrollView addSubview:add2View];
    [scrollView addSubview:add3View];
    
    [add1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(scrollView);
    }];
    [add2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(add1View.mas_bottom).mas_offset(10);
    }];
    [add3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(add2View.mas_bottom).mas_offset(10);
    }];
    
    self.submitButton = button;
}

- (UIView *)imageAddView:(NSUInteger)index {
    
    UIView *addView = [[UIView alloc] init];
    addView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.titleList[index];
    titleLabel.numberOfLines = 0;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineColor;
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = [UIFont systemFontOfSize:12.0f];
    noticeLabel.textColor = [UIColor grayColor];
    noticeLabel.text = self.noticeList[index];
    noticeLabel.numberOfLines = 0;
    
    UIButton *sampleButton = [[UIButton alloc] init];
    [sampleButton setTitle:@"点击查看示例图片>" forState:UIControlStateNormal];
    [sampleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sampleButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    sampleButton.tag = (index + 1);
    [sampleButton addTarget:self action:@selector(showSampleImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *attentionLabel = [[UILabel alloc] init];
    attentionLabel.font = [UIFont systemFontOfSize:12.0f];
    attentionLabel.textColor = [UIColor redColor];
    attentionLabel.text = @"注意: 照片上传后，其他用户可见。本照片允许修改1次。";
    attentionLabel.numberOfLines = 0;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.layer.borderColor = kLineColor.CGColor;
    imageView.layer.borderWidth = 1.0;
    imageView.image = [UIImage imageNamed:@"add"];
    imageView.tag = (index + 1);
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    UIImageView *delImageView = [[UIImageView alloc] init];
    delImageView.contentMode = UIViewContentModeScaleToFill;
    delImageView.image = [UIImage imageNamed:@"delete"];
    delImageView.hidden = YES;
    delImageView.tag = (11 * (index + 1));
    delImageView.userInteractionEnabled = YES;
    [delImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)]];
    
    [addView addSubview:titleLabel];
    [addView addSubview:lineView];
    [addView addSubview:noticeLabel];
    [addView addSubview:sampleButton];
    [addView addSubview:attentionLabel];
    [addView addSubview:imageView];
    [addView addSubview:delImageView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addView).mas_offset(15);
        make.top.mas_equalTo(addView).mas_offset(5);
        make.height.mas_greaterThanOrEqualTo(20);
        make.right.mas_equalTo(addView).mas_offset(-15);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(addView);
    }];
    noticeLabel.preferredMaxLayoutWidth = (kScreenWidth - 30);
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(titleLabel);
    }];
    [sampleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(noticeLabel.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(20);
    }];
    attentionLabel.preferredMaxLayoutWidth = (kScreenWidth - 30);
    [attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(sampleButton.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(titleLabel);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(attentionLabel.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(addView).mas_offset(-5);
        make.right.mas_equalTo(titleLabel);
        make.height.mas_equalTo(imageView.mas_width).multipliedBy((float)9/16);
    }];
    [delImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.mas_right).mas_offset(-2.5);
        make.centerY.mas_equalTo(imageView.mas_top).mas_offset(2.5);
        make.width.height.mas_equalTo(15);
    }];
    
    if (index == 0) {
        self.imageView1 = imageView;
        self.delImageView1 = delImageView;
    } else if (index == 1) {
        self.imageView2 = imageView;
        self.delImageView2 = delImageView;
    } else if (index == 2) {
        self.imageView3 = imageView;
        self.delImageView3 = delImageView;
    }
    
    return addView;
}

#pragma mark - getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
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

- (NSArray *)titleList {
    if (!_titleList) {
        _titleList = @[
                       @"身份验证(请上传您的身份证照片)",
                       @"学历验证(请上传您的毕业证书照片)",
                       @"职务验证(请上传您的单位名片照片)"
                       ];
    }
    return _titleList;
}

- (NSArray *)noticeList {
    if (!_noticeList) {
        _noticeList = @[
                        @"保护隐私，请自行遮盖敏感信息。但请确保姓氏、出生年份、身份证前12位信息清晰可见",
                        @"保护隐私，请自行遮盖敏感信息。但请确保学校名称、证书编号、姓氏、毕业年份等清晰可见",
                        @"保护隐私，请自行遮盖敏感信息。但请确保姓氏、公司名称、职务抬头信息清晰可见"
                        ];
    }
    return _noticeList;
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEdit:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
}

- (void)showSampleImage:(UIButton *)button {
    
    NSString *imageUrl = [NSString stringWithFormat:@"http://www.viewatmobile.cn:80/3025/pages/img/demo0%ld.jpg", button.tag];
    [ImageBrowser show:@[imageUrl] currentIndex:0];
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    
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

#pragma mark - 数据处理

/**
 *  加载数据
 */
- (void)loadData {
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [activityIndicatorView startAnimating];
    
    NSString *sql = [NSString stringWithFormat:@"\
                     select \
                         images_ID, \
                         imageIDUpdateNumber, \
                         imageIDUpdatetime, \
                         images_education, \
                         imageEducationUpdateNumber, \
                         imageEducationUpdatetime, \
                         images_position, \
                         imagePositionUpdateNumber, \
                         imagePositionUpdatetime \
                     FROM \
                         user \
                     where \
                         userid = %@", self.userid];
    
    // 筛选条件
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *parameterDict = @{ @"sql": sql };
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = responseDict[@"list"];
        
        if (array.count == 1) {
            
            NSDictionary *dict = array[0];
            
            if ([ConversionUtil isNotEmpty:dict[@"images_ID"]]) {
                
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:dict[@"images_ID"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image && !error) {
                        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
                        self.imageView1.layer.masksToBounds = YES;
                        self.delImageView1.hidden = NO;
                    }
                }];
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"images_education"]]) {
                
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:dict[@"images_education"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image && !error) {
                        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
                        self.imageView2.layer.masksToBounds = YES;
                        self.delImageView2.hidden = NO;
                    }
                }];
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"images_position"]]) {
                
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:dict[@"images_position"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image && !error) {
                        self.imageView3.contentMode = UIViewContentModeScaleAspectFill;
                        self.imageView3.layer.masksToBounds = YES;
                        self.delImageView3.hidden = NO;
                    }
                }];
            }
            
            if ([dict[@"imageIDUpdateNumber"] intValue] > 1 && [dict[@"imageEducationUpdateNumber"] intValue] > 1 && [dict[@"imagePositionUpdateNumber"] intValue] > 1) {

                self.submitButton.enabled = NO;
            }
        }
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    }];
}

- (void)publish:(UIButton *)button {
    
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
    
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"update "];
    [sql appendString:@"    user "];
    [sql appendString:@"set "];
    
    if (image1) {
        
        NSData *imageData = UIImageJPEGRepresentation(image1, 0.9);
        image1Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image1Key];

        [sql appendString:@"    images_ID = 'http://oqauefc7p.bkt.clouddn.com/"];
        [sql appendString:image1Key];
        [sql appendString:@"', "];
        [sql appendString:@"    imageIDUpdateNumber = (imageIDUpdateNumber + 1), "];
        [sql appendString:@"    imageIDUpdatetime = now(), "];
    }
    if (image2) {
        
        NSData *imageData = UIImageJPEGRepresentation(image2, 0.9);
        image2Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image2Key];

        [sql appendString:@"    images_education = 'http://oqauefc7p.bkt.clouddn.com/"];
        [sql appendString:image2Key];
        [sql appendString:@"', "];
        [sql appendString:@"    imageEducationUpdateNumber = (imageEducationUpdateNumber + 1), "];
        [sql appendString:@"    imageEducationUpdatetime = now(), "];
    }
    if (image3) {
        
        NSData *imageData = UIImageJPEGRepresentation(image3, 0.9);
        image3Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image3Key];
        
        [sql appendString:@"    images_position = 'http://oqauefc7p.bkt.clouddn.com/"];
        [sql appendString:image3Key];
        [sql appendString:@"',"];
        [sql appendString:@"    imagePositionUpdateNumber = (imagePositionUpdateNumber + 1), "];
        [sql appendString:@"    imagePositionUpdatetime = now(), "];
    }
    [sql appendString:@"    updatetime = now() "];
    [sql appendString:@"where"];
    [sql appendString:@"    userid = "];
    [sql appendString:self.userid];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *parameter = @{ @"sql" : sql };
    
    [HttpUtil query:url parameter:parameter success:^(id responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** success %@ ***", responseDict);
        
        [SVProgressHUD showImage:nil status:@"提交成功"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
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
