//
//  MatchViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "MatchViewController.h"

@interface MatchViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *dadTextView;
@property (nonatomic, strong) UITextView *mumTextView;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *streetTextField;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *delImageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *delImageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *delImageView3;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableDictionary *imageDataDict;
@property (nonatomic, copy) NSArray *provinceList;
@property (nonatomic, copy) NSArray *cityList;
@property (nonatomic, copy) NSArray *districtList;
@property (nonatomic, copy) NSMutableArray *images_address;

@property (nonatomic, strong) NSMutableArray *optionValueList;

@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigtion];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    float imageHeight = (kScreenWidth - 50) / 3 * 9 / 16;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, imageHeight + 970 + 64);
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
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    UIView *importView = [self option:@[@"三观匹配", @"门当户对", @"三观、门户都重要"] title:@"请最少选择1项择偶条件" category:0];
    UIView *fatherView = [self option:@[@"退休", @"在职", @"其他"] title:@"我的父亲" category:1];
    
    // 说明
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.font = [UIFont systemFontOfSize:16.0f];
    titleLabel2.textColor = [UIColor blackColor];
    titleLabel2.text = @"说明";
    
    // 内容输入框
    UITextView *textView2 = [[UITextView alloc] init];
    textView2.font = [UIFont systemFontOfSize:16.0f];
    textView2.textColor = [UIColor blackColor];
    textView2.layer.borderColor = kLineColor.CGColor;
    textView2.layer.borderWidth = 1.0;
    
    UIView *matherView = [self option:@[@"退休", @"在职", @"其他"] title:@"我的母亲" category:2];
    
    self.optionValueList = [NSMutableArray array];
    [self.optionValueList addObject:@"三观匹配"];
    [self.optionValueList addObject:@"退休"];
    [self.optionValueList addObject:@"退休"];
    
    // 添加标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"说明";
    
    // 内容输入框
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = [UIColor blackColor];
    textView.layer.borderColor = kLineColor.CGColor;
    textView.layer.borderWidth = 1.0;
    
    UIView *homeEditView = [self homeEditView];
    
    // 图片上传区域
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor whiteColor];
    
    // 上传照片（最多三张，可选填）
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    subTitleLabel.textColor = [UIColor blackColor];
    subTitleLabel.text = @"房屋照片（最多三张）";
    
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
        make.left.mas_equalTo(middleView).mas_offset(15);
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
    
    [scrollView addSubview:importView];
    [scrollView addSubview:fatherView];
    [scrollView addSubview:titleLabel2];
    [scrollView addSubview:textView2];
    [scrollView addSubview:matherView];
    [scrollView addSubview:titleLabel];
    [scrollView addSubview:textView];
    [scrollView addSubview:homeEditView];
    [scrollView addSubview:middleView];
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    
    [importView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(scrollView);
    }];
    [fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(importView.mas_bottom);
    }];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fatherView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(scrollView).mas_offset(15);
    }];
    [textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel2);
        make.top.mas_equalTo(titleLabel2.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(120);
    }];
    [matherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(textView2.mas_bottom).mas_offset(0);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView).mas_offset(15);
        make.top.mas_equalTo(matherView.mas_bottom).mas_offset(10);
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(120);
    }];
    [homeEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(textView.mas_bottom).mas_offset(0);
    }];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(scrollView);
        make.top.mas_equalTo(homeEditView.mas_bottom).mas_offset(10);
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
    
    self.scrollView = scrollView;
    self.dadTextView = textView2;
    self.mumTextView = textView;
    self.imageView1 = imageView1;
    self.imageView2 = imageView2;
    self.imageView3 = imageView3;
    self.delImageView1 = delImageView1;
    self.delImageView2 = delImageView2;
    self.delImageView3 = delImageView3;
    
    self.shadeView.hidden = NO;
    self.inputView.hidden = NO;
}

- (UIView *)option:(NSArray *)optionList title:(NSString *)title category:(NSUInteger)category {
    
    UIView *optionView = [[UIView alloc] init];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = kBackgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    
    UIView *itemView = [[UIView alloc] init];
    itemView.backgroundColor = [UIColor whiteColor];
    
    [optionView addSubview:titleView];
    [optionView addSubview:titleLabel];
    [optionView addSubview:itemView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(optionView);
        make.height.mas_equalTo(40);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(optionView).mas_offset(15);
        make.center.mas_equalTo(titleView);
    }];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom);
        make.left.width.mas_equalTo(optionView);
        make.height.mas_equalTo(40*optionList.count);
        make.bottom.mas_equalTo(optionView);
    }];
    
    for (NSString *option in optionList) {
        
        NSUInteger index = [optionList indexOfObject:option];
        
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.font = [UIFont systemFontOfSize:14.0f];
        itemLabel.textColor = [UIColor blackColor];
        itemLabel.text = option;
        itemLabel.userInteractionEnabled = YES;
        [itemLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionSelect:)]];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineColor;
        
        [optionView addSubview:itemLabel];
        [optionView addSubview:lineView];
        
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemView).mas_offset(40*index);
            make.left.mas_equalTo(titleLabel);
            make.right.mas_equalTo(optionView);
            make.height.mas_equalTo(40);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(itemLabel);
            make.left.mas_equalTo(itemLabel);
            make.right.mas_equalTo(optionView);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"checked"];
    imageView.tag = category;
    
    [optionView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(itemView);
        make.right.mas_equalTo(optionView).mas_offset(-15);
        make.width.height.mas_equalTo(40);
    }];
    
    return optionView;
}

- (UIView *)homeEditView {
    
    UIView *homeView = [[UIView alloc] init];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = kBackgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"这是我家:(其他用户可见，注意保护隐私)";
    titleLabel.numberOfLines = 0;
    
    UIView *itemView = [[UIView alloc] init];
    itemView.backgroundColor = [UIColor whiteColor];
    
    [homeView addSubview:titleView];
    [homeView addSubview:titleLabel];
    [homeView addSubview:itemView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(homeView);
        make.height.mas_equalTo(40);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeView).mas_offset(15);
        make.center.mas_equalTo(titleView);
    }];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom);
        make.left.width.mas_equalTo(homeView);
        make.height.mas_equalTo(80);
        make.bottom.mas_equalTo(homeView);
    }];
    
    // 添加标题
    UILabel *item1Label = [[UILabel alloc] init];
    item1Label.font = [UIFont systemFontOfSize:14.0f];
    item1Label.textColor = [UIColor blackColor];
    item1Label.text = @"城市/区县";
    
    UIView *vLineView = [[UIView alloc] init];
    vLineView.backgroundColor = kLineColor;
    
    // 内容输入框
    UITextField *textView = [[UITextField alloc] init];
    textView.layer.borderColor = kLineColor.CGColor;
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 5;
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textColor = [UIColor blackColor];
    textView.delegate = self;
    
    UIView *hLineView = [[UIView alloc] init];
    hLineView.backgroundColor = kLineColor;
    
    // 添加标题
    UILabel *item2Label = [[UILabel alloc] init];
    item2Label.font = [UIFont systemFontOfSize:14.0f];
    item2Label.textColor = [UIColor blackColor];
    item2Label.text = @"靠近什么路?";
    
    UIView *vLineView2 = [[UIView alloc] init];
    vLineView2.backgroundColor = kLineColor;
    
    // 内容输入框
    UITextField *textView2 = [[UITextField alloc] init];
    textView2.layer.borderColor = kLineColor.CGColor;
    textView2.layer.borderWidth = 1.0;
    textView2.layer.cornerRadius = 5;
    textView2.font = [UIFont systemFontOfSize:14.0f];
    textView2.textColor = [UIColor blackColor];
    textView2.delegate = self;
    
    UIView *hLine2View = [[UIView alloc] init];
    hLine2View.backgroundColor = kLineColor;
    
    [homeView addSubview:item1Label];
    [homeView addSubview:vLineView];
    [homeView addSubview:textView];
    [homeView addSubview:hLineView];
    [homeView addSubview:item2Label];
    [homeView addSubview:vLineView2];
    [homeView addSubview:textView2];
    [homeView addSubview:hLine2View];
    
    [item1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom);
        make.left.mas_equalTo(titleLabel);
        make.width.mas_equalTo(item2Label);
        make.height.mas_equalTo(40);
    }];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(item1Label);
        make.left.mas_equalTo(item1Label.mas_right).mas_offset(10);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(15);
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(item1Label);
        make.left.mas_equalTo(vLineView.mas_right).mas_offset(10);
        make.right.mas_equalTo(homeView).mas_offset(-15);
        make.height.mas_equalTo(25);
    }];
    [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(item1Label);
        make.left.mas_equalTo(item1Label);
        make.right.mas_equalTo(homeView);
        make.height.mas_equalTo(0);
    }];
    [item2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(item1Label.mas_bottom);
        make.left.mas_equalTo(item1Label);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    [vLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(item2Label);
        make.left.mas_equalTo(item2Label.mas_right).mas_offset(10);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(15);
    }];
    [textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(item2Label);
        make.left.mas_equalTo(vLineView2.mas_right).mas_offset(10);
        make.right.mas_equalTo(homeView).mas_offset(-15);
        make.height.mas_equalTo(25);
    }];
    [hLine2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(item2Label);
        make.left.mas_equalTo(item2Label);
        make.right.mas_equalTo(homeView);
        make.height.mas_equalTo(0);
    }];
    
    self.cityTextField = textView;
    self.streetTextField = textView2;
    
    return homeView;
}

#pragma mark - getter

- (NSArray *)provinceList {
    
    if (!_provinceList) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd" ofType:@"plist"];
        NSDictionary *pcdDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:[pcdDict objectForKey:@"province"]];
        [mArr removeObjectAtIndex:0];
        
        _provinceList = [NSArray arrayWithArray:mArr];
    }
    
    return _provinceList;
}

- (NSArray *)cityList {
    
    if (!_cityList) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd" ofType:@"plist"];
        NSDictionary *pcdDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:[pcdDict objectForKey:@"city"]];
        [mArr removeObjectAtIndex:0];
        
        _cityList = [NSArray arrayWithArray:mArr];
    }
    
    return _cityList;
}

- (NSArray *)districtList {
    
    if (!_districtList) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pcd" ofType:@"plist"];
        NSDictionary *pcdDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:[pcdDict objectForKey:@"district"]];
        [mArr removeObjectAtIndex:0];
        
        _districtList = [NSArray arrayWithArray:mArr];
    }
    
    return _districtList;
}

- (NSMutableArray *)images_address {
    if (!_images_address) {
        _images_address = [NSMutableArray arrayWithCapacity:3];
        [_images_address addObject:@""];
        [_images_address addObject:@""];
        [_images_address addObject:@""];
    }
    return _images_address;
}

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

- (UIView *)shadeView {
    
    if (!_shadeView) {
        
        _shadeView = [[UIView alloc] init];
        _shadeView.backgroundColor = [UIColor clearColor];
        [_shadeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelInput:)]];
        
        [self.view addSubview:_shadeView];
        [self.view sendSubviewToBack:_shadeView];
        
        [_shadeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    return _shadeView;
}

- (UIView *)inputView {
    
    if (!_inputView) {
        
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = kButtonColor;
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelInput:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.text = @"城市／县区";
        
        UIButton *okButton = [[UIButton alloc] init];
        [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [okButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(submitInput:) forControlEvents:UIControlEventTouchUpInside];
        
        [_inputView addSubview:cancelButton];
        [_inputView addSubview:titleLabel];
        [_inputView addSubview:okButton];
        [_inputView addSubview:self.pickerView];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inputView);
            make.left.mas_equalTo(_inputView);
            make.width.mas_equalTo(57);
            make.height.mas_equalTo(30);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(cancelButton);
            make.centerX.mas_equalTo(_inputView);
        }];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.width.mas_equalTo(cancelButton);
            make.right.mas_equalTo(_inputView);
        }];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.width.mas_equalTo(_inputView);
            make.height.mas_equalTo(216);
        }];
        
        [self.view addSubview:_inputView];
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).mas_offset(0);
            make.left.width.mas_equalTo(self.view);
            make.height.mas_equalTo(246);
        }];
    }
    
    return _inputView;
}

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = kBackgroundColor;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.provinceList.count;
    } else if (component == 1) {
        
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        return [self.cityList[selectedRow] count];
    } else if (component == 2) {
        
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSInteger selectedRow2 = [pickerView selectedRowInComponent:1];
        return [self.districtList[selectedRow][selectedRow2] count];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.provinceList[row];
    } else if (component == 1) {
        
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        return self.cityList[selectedRow][row];
    } else if (component == 2) {
        
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSInteger selectedRow2 = [pickerView selectedRowInComponent:1];
        return self.districtList[selectedRow][selectedRow2][row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    } else if (component == 1) {
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.cityTextField) {
        
        self.shadeView.backgroundColor = [UIColor blackColor];
        [self.view bringSubviewToFront:self.shadeView];
        [self.shadeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        [self.view bringSubviewToFront:self.inputView];
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).mas_offset(-246);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
        
        return NO;
    }

    return YES;
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
    
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEdit:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
}

- (void)optionSelect:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
    
    UILabel *itemLabel = (UILabel *)tapGestureRecognizer.view;
    NSArray *subviews = tapGestureRecognizer.view.superview.subviews;
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            
            [subview mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(itemLabel).mas_offset(-15);
                make.centerY.mas_equalTo(itemLabel);
                make.width.height.mas_equalTo(40);
            }];
            
            NSInteger tag2 = subview.tag;
            [self.optionValueList replaceObjectAtIndex:tag2 withObject:itemLabel.text];
        }
    }
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    [self.view endEditing:YES];
    
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
                [self.images_address replaceObjectAtIndex:0 withObject:@""];
                break;
            case 22:
                self.imageView2.contentMode = UIViewContentModeCenter;
                self.imageView2.image = [UIImage imageNamed:@"add"];
                self.delImageView2.hidden = YES;
                [self.imageDataDict removeObjectForKey:@"image2"];
                [self.images_address replaceObjectAtIndex:1 withObject:@""];
                break;
            case 33:
                self.imageView3.contentMode = UIViewContentModeCenter;
                self.imageView3.image = [UIImage imageNamed:@"add"];
                self.delImageView3.hidden = YES;
                [self.imageDataDict removeObjectForKey:@"image3"];
                [self.images_address replaceObjectAtIndex:2 withObject:@""];
                break;
            default:
                break;
        }
    }
}

- (void)cancelInput:(UITapGestureRecognizer *)gestureRecognizer {
    
    [self.view endEditing:YES];
    
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.shadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.view sendSubviewToBack:self.shadeView];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    if (self.dadTextView.isFirstResponder) {
        
        CGRect frame = self.dadTextView.frame;
        contentOffset = CGPointMake(0, frame.origin.y - 40);
    } else if (self.mumTextView.isFirstResponder) {
        
        CGRect frame = self.mumTextView.frame;
        contentOffset = CGPointMake(0, frame.origin.y - 40);
    } else if (self.streetTextField.isFirstResponder) {
        
        CGRect frame = self.streetTextField.superview.frame;
        contentOffset = CGPointMake(0, frame.origin.y);
    }

    [UIView animateWithDuration:duration animations:^{
        
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        if (finished) {
            self.scrollView.scrollEnabled = NO;
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGSize contentSize = self.scrollView.contentSize;
    if (contentOffset.y > (contentSize.height - self.scrollView.frame.size.height)) {
        
        float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        contentOffset.y = (contentSize.height - self.scrollView.frame.size.height);
        
        [UIView animateWithDuration:duration animations:^{
            
            self.scrollView.contentOffset = contentOffset;
        } completion:^(BOOL finished) {
            if (finished) {
                self.scrollView.scrollEnabled = YES;
            }
        }];
    } else {
        
        self.scrollView.scrollEnabled = YES;
    }
}

- (void)submitInput:(UIButton *)button {
    
    NSString *selectedTitle = @"";

    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    NSInteger selectedRow2 = [self.pickerView selectedRowInComponent:1];
    NSInteger selectedRow3 = [self.pickerView selectedRowInComponent:2];
    
    NSString *province = self.provinceList[selectedRow];
    NSString *city = self.cityList[selectedRow][selectedRow2];
    NSString *district = self.districtList[selectedRow][selectedRow2][selectedRow3];
    
    province = [province stringByReplacingOccurrencesOfString:@"省" withString:@""];
    province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
    city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    selectedTitle = [NSString stringWithFormat:@"%@-%@-%@", province, city, district];
    self.cityTextField.text = selectedTitle;
    
    [self cancelInput:self.shadeView.gestureRecognizers.firstObject];
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
                        important, \
                        father_job, \
                        father_comment, \
                        mother_job, \
                        mother_comment, \
                        address, \
                        address_comment, \
                        images_address \
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
            
            if ([ConversionUtil isNotEmpty:dict[@"important"]]) {
                
                UIView *optionView = self.scrollView.subviews.firstObject;
                
                for (UIView *subview in optionView.subviews) {
                    
                    if ([subview isKindOfClass:[UILabel class]]) {
                        
                        UILabel *itemLabel = (UILabel *)subview;
                        if ([itemLabel.text isEqualToString:dict[@"important"]]) {
                            
                            [self optionSelect:itemLabel.gestureRecognizers.firstObject];
                            break;
                        }
                    }
                }
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"father_job"]]) {
                
                UIView *optionView = self.scrollView.subviews[1];
                
                for (UIView *subview in optionView.subviews) {
                    
                    if ([subview isKindOfClass:[UILabel class]]) {
                        
                        UILabel *itemLabel = (UILabel *)subview;
                        if ([itemLabel.text isEqualToString:dict[@"father_job"]]) {
                            
                            [self optionSelect:itemLabel.gestureRecognizers.firstObject];
                            break;
                        }
                    }
                }
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"father_comment"]]) {

                self.dadTextView.text = dict[@"father_comment"];
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"mother_job"]]) {
                
                UIView *optionView = self.scrollView.subviews[4];
                
                for (UIView *subview in optionView.subviews) {
                    
                    if ([subview isKindOfClass:[UILabel class]]) {
                        
                        UILabel *itemLabel = (UILabel *)subview;
                        if ([itemLabel.text isEqualToString:dict[@"father_job"]]) {
                            
                            [self optionSelect:itemLabel.gestureRecognizers.firstObject];
                            break;
                        }
                    }
                }
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"mother_comment"]]) {
                
                self.mumTextView.text = dict[@"mother_comment"];
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"address"]]) {
                
                self.cityTextField.text = dict[@"address"];
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"address_comment"]]) {
                
                self.streetTextField.text = dict[@"address_comment"];
            }
            
            if ([ConversionUtil isNotEmpty:dict[@"images_address"]]) {
                
                NSArray *imageList = [dict[@"images_address"] componentsSeparatedByString:@","];
                if (imageList.count == 3) {
                    if ([ConversionUtil isNotEmpty:imageList[0]]) {
                        
                        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imageList[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if (image && !error) {
                                self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
                                self.imageView1.layer.masksToBounds = YES;
                                self.delImageView1.hidden = NO;
                            }
                        }];
                        [self.images_address replaceObjectAtIndex:0 withObject:imageList[0]];
                    }
                    if ([ConversionUtil isNotEmpty:imageList[1]]) {
                        
                        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:imageList[1]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if (image && !error) {
                                self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
                                self.imageView2.layer.masksToBounds = YES;
                                self.delImageView2.hidden = NO;
                            }
                        }];
                        [self.images_address replaceObjectAtIndex:1 withObject:imageList[1]];
                    }
                    if ([ConversionUtil isNotEmpty:imageList[2]]) {
                        
                        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:imageList[2]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if (image && !error) {
                                self.imageView3.contentMode = UIViewContentModeScaleAspectFill;
                                self.imageView3.layer.masksToBounds = YES;
                                self.delImageView3.hidden = NO;
                            }
                        }];
                        [self.images_address replaceObjectAtIndex:2 withObject:imageList[2]];
                    }
                }
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
    
    if (image1) {
        
        NSData *imageData = UIImageJPEGRepresentation(image1, 0.9);
        image1Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image1Key];
        
        [self.images_address replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image1Key]];
    }
    if (image2) {
        
        NSData *imageData = UIImageJPEGRepresentation(image2, 0.9);
        image2Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image2Key];
        
        [self.images_address replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image2Key]];
    }
    if (image3) {
        
        NSData *imageData = UIImageJPEGRepresentation(image3, 0.9);
        image3Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
        
        [QiniuUtil upload:imageData key:image3Key];
        
        [self.images_address replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image3Key]];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:@"user" forKey:@"table"];
    [parameter setObject:self.userid forKey:@"userid"];
    [parameter setValue:[NSString stringWithFormat:@"id is null and userid = '%@' ", self.userid] forKey:@"id"];
    [parameter setObject:self.userid forKey:@"updateUser"];
    
    [parameter setObject:self.optionValueList[0] forKey:@"important"];
    [parameter setObject:self.optionValueList[1] forKey:@"father_job"];
    [parameter setObject:self.optionValueList[2] forKey:@"mother_job"];
    
    [parameter setObject:[self.images_address componentsJoinedByString:@","] forKey:@"images_address"];
    
    NSString *text = [self.dadTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [parameter setObject:text forKey:@"father_comment"];
    
    text = [self.mumTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [parameter setObject:text forKey:@"mother_comment"];
    
    text = [self.cityTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [parameter setObject:text forKey:@"address"];

    text = [self.streetTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [parameter setObject:text forKey:@"address_comment"];
    
    NSLog(@"*** parameter %@ ***", parameter);
    
    [HttpUtil query:url parameter:parameter success:^(id responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"*** success %@ ***", responseDict);
        
        if ([responseDict[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD showImage:nil status:@"提交成功"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
            
            [activityIndicatorView stopAnimating];
            [activityIndicatorView removeFromSuperview];
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
