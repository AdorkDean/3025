//
//  BaseViewController.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "BaseViewController.h"
#import "PropertyCell.h"

@interface BaseViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PropertyCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, copy) NSArray *pickerList;
@property (nonatomic, copy) NSArray *provinceList;
@property (nonatomic, copy) NSArray *cityList;
@property (nonatomic, assign) NSUInteger currentRow;
@property (nonatomic, copy) NSMutableArray *images_address;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableDictionary *imageDataDict;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *delImageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *delImageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *delImageView3;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITextView *signatureTextView;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *inputTitleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation BaseViewController

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
    titleLabel.text = @"基本资料";
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kBackgroundColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = self.footerView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = kLineColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = kButtonColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tableView];
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
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
    
    self.tableView = tableView;
    
    self.shadeView.hidden = NO;
    self.inputView.hidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.titleList[indexPath.row];
    static NSString *cellID = @"PropertyCell";
    
    PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setMulti:(indexPath.row == 0)];
    [cell setIndexPath:indexPath];
    [cell setDelegate:self];
    [cell setupData:dict];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (self.currentRow == 5 || self.currentRow == 6) {
        
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.currentRow == 5 || self.currentRow == 6) {
        if (component == 0) {
            
            return self.provinceList.count;
        } else if (component == 1) {
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            return [self.cityList[selectedRow] count];
        }
    }
    
    return self.pickerList.count;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (self.currentRow == 5 || self.currentRow == 6) {
        if (component == 0) {
            
            return self.provinceList[row];
        } else if (component == 1) {
            
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            return self.cityList[selectedRow][row];
        }
    }
    
    return self.pickerList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.currentRow == 5 || self.currentRow == 6) {
        if (component == 0) {
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@" *** %@ %@ %@ *** ", NSStringFromCGSize(self.tableView.bounds.size), NSStringFromCGSize(self.tableView.contentSize), NSStringFromCGPoint(self.tableView.contentOffset));
}

#pragma mark - PropertyCellDelegate

- (void)input:(NSIndexPath *)indexPath {
    
    self.currentRow = indexPath.row;
    
    // 昵称 || 职位
    if (indexPath.row == 1 || indexPath.row == 10) {
        return;
    }
    
    // 头像
    if (indexPath.row == 0) {

        self.imageIndex = 9;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];

        return;
    }
    
    NSDictionary *dict = self.titleList[indexPath.row];
    self.inputTitleLabel.text = dict[@"title"];
    
    if (self.currentRow == 5 || self.currentRow == 6) {
        
        NSUInteger selectedRow = 0;
        NSUInteger selectedRow2 = 0;
        
        if ([ConversionUtil isNotEmpty:dict[@"value"]]) {
            
            NSString *selectedTitle = dict[@"value"];
            NSString *province = selectedTitle;
            NSString *city = selectedTitle;
            
            if ([selectedTitle containsString:@"-"]) {
                
                NSArray *arr = [selectedTitle componentsSeparatedByString:@"-"];
                if (arr.count == 2) {
                    
                    province = arr[0];
                    city = arr[1];
                }
            }
            
            for (int i = 0; i < self.provinceList.count; i++) {
                if ([self.provinceList[i] hasPrefix:province]) {

                    selectedRow = i;
                    
                    NSArray *arr = self.cityList[selectedRow];
                    for (int j = 0; j < arr.count; j++) {
                        if ([arr[j] hasPrefix:city]) {
                            selectedRow2 = j;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        
        [self.pickerView reloadAllComponents];
        [self.pickerView reloadComponent:0];
        [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:selectedRow2 inComponent:1 animated:NO];
    } else {
        
        [self setupPickerList:self.currentRow];
        
        NSString *selectedTitle = dict[@"value"];
        NSInteger selectedRow = [self.pickerList indexOfObject:selectedTitle];
        if (selectedRow < 0 || selectedRow >= self.pickerList.count) {
            selectedRow = 0;
        }
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
    }
    
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
}

- (void)inputComplete:(NSString *)text {
    
    if (self.currentRow == 1 || self.currentRow == 10) {
        
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.titleList];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[self.currentRow]];

        [mDict setObject:text forKey:@"value"];
            
        [mArr replaceObjectAtIndex:self.currentRow withObject:[NSDictionary dictionaryWithDictionary:mDict]];
        
        [self setTitleList:[NSArray arrayWithArray:mArr]];
    }
}

#pragma mark - getter and setter


- (UIView *)footerView {
    
    if (!_footerView) {
        
        float imageHeight = (kScreenWidth - 50) / 3 * 9 / 16;
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = kBackgroundColor;
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, (imageHeight + 390));
        
        // 图片上传区域
        UIView *pictureView = [[UIView alloc] init];
        pictureView.backgroundColor = [UIColor whiteColor];
        
        // 上传照片（最多三张，可选填）
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        subTitleLabel.textColor = [UIColor blackColor];
        subTitleLabel.text = @"个人照片（最多三张）";
        
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
        
        [pictureView addSubview:subTitleLabel];
        [pictureView addSubview:imageView1];
        [pictureView addSubview:delImageView1];
        [pictureView addSubview:imageView2];
        [pictureView addSubview:delImageView2];
        [pictureView addSubview:imageView3];
        [pictureView addSubview:delImageView3];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pictureView).mas_offset(15);
            make.top.mas_equalTo(pictureView).mas_offset(10);
            make.right.mas_equalTo(pictureView).mas_offset(-15);
            make.height.mas_equalTo(20);
        }];
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(subTitleLabel);
            make.top.mas_equalTo(subTitleLabel.mas_bottom).mas_offset(10);
            //make.bottom.mas_equalTo(pictureView).mas_offset(-10);
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
            make.right.mas_equalTo(pictureView).mas_offset(-20);
        }];
        [delImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView3.mas_right).mas_offset(-2.5);
            make.centerY.mas_equalTo(imageView3.mas_top).mas_offset(2.5);
            make.width.height.mas_equalTo(15);
        }];
        
        // 添加标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"个性签名：";
        
        // 内容输入框
        UITextView *textView = [[UITextView alloc] init];
        textView.font = [UIFont systemFontOfSize:16.0f];
        textView.textColor = [UIColor blackColor];
        textView.layer.borderColor = kLineColor.CGColor;
        textView.layer.borderWidth = 1.0;

        // 添加标题
        UILabel *titleLabel2 = [[UILabel alloc] init];
        titleLabel2.font = [UIFont systemFontOfSize:16.0f];
        titleLabel2.textColor = [UIColor blackColor];
        titleLabel2.text = @"补充说明：";
        
        // 内容输入框
        UITextView *textView2 = [[UITextView alloc] init];
        textView2.font = [UIFont systemFontOfSize:16.0f];
        textView2.textColor = [UIColor blackColor];
        textView2.layer.borderColor = kLineColor.CGColor;
        textView2.layer.borderWidth = 1.0;
        
        [_footerView addSubview:pictureView];
        [_footerView addSubview:titleLabel];
        [_footerView addSubview:textView];
        [_footerView addSubview:titleLabel2];
        [_footerView addSubview:textView2];
        
        [pictureView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView);
            make.top.mas_equalTo(_footerView).mas_offset(10);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo((imageHeight + 50));
        }];
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView).mas_offset(15);
            make.top.mas_equalTo(pictureView.mas_bottom);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(_footerView);
        }];
        [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth-30);
            make.height.mas_equalTo(120);
        }];
        [titleLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_footerView).mas_offset(15);
            make.top.mas_equalTo(textView.mas_bottom);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(_footerView);
        }];
        [textView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel2);
            make.top.mas_equalTo(titleLabel2.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth-30);
            make.height.mas_equalTo(120);
        }];
        
        self.imageView1 = imageView1;
        self.imageView2 = imageView2;
        self.imageView3 = imageView3;
        self.delImageView1 = delImageView1;
        self.delImageView2 = delImageView2;
        self.delImageView3 = delImageView3;
        self.signatureTextView = textView;
        self.commentTextView = textView2;
    }
    
    return _footerView;
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

- (NSArray *)titleList {
    
    if (!_titleList) {
        _titleList = @[
                       @{ @"title": @"头像", @"value": @"" },
                       @{ @"title": @"昵称", @"value": @"" },
                       @{ @"title": @"性别", @"value": @"男" },
                       @{ @"title": @"身高", @"value": @"175" },
                       @{ @"title": @"出生年份", @"value": @"1987-11-11"},
                       @{ @"title": @"常住城市", @"value": @"上海-上海" },
                       @{ @"title": @"户籍", @"value": @"浙江-杭州" },
                       @{ @"title": @"婚房", @"value": @"01" },
                       @{ @"title": @"最高学历", @"value": @"01" },
                       @{ @"title": @"单位性质", @"value": @"01" },
                       @{ @"title": @"职务", @"value": @"教师" },
                       @{ @"title": @"月收入", @"value": @"8000" },
                       @{ @"title": @"婚姻状态", @"value": @"01" },
                       ];
    }
    
    return _titleList;
}

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


- (void)setupPickerList:(NSUInteger)type {
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    if (type == 2) { // 性别
        
        [mArr addObject:@"男"];
        [mArr addObject:@"女"];
    } else if (type == 4) { // 年龄
        
        int year = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyy"].intValue;
        for (int i = (year - 60); i <= (year - 20); i++) {
            [mArr addObject:[NSString stringWithFormat:@"%d年", i]];
        }
    } else if (type == 3) { // 身高
        
        for (int i=140; i<=200; i++) {
            [mArr addObject:[NSString stringWithFormat:@"%dcm", i]];
        }
    } else if (type == 5) { // 户籍
        
    } else if (type == 6) { // 常住城市
        
    } else if (type == 8) { // 最高学历
        
        for (NSString *item in kEducation) {
            [mArr addObject:[NSString stringWithFormat:@"%@", item]];
        }
    } else if (type == 11) { // 月收入
        
        [mArr addObject:[NSString stringWithFormat:@"%d以下", 3000]];
        for (int i=3; i<=50; i++) {
            [mArr addObject:[NSString stringWithFormat:@"%d以上", i*1000]];
        }
    } else if (type == 9) { // 单位性质
        
        [mArr addObjectsFromArray:kUnitNature];
    } else if (type == 12) { // 婚姻状态
        
        [mArr addObjectsFromArray:kMaritalStatus];
    } else if (type == 7) { // 婚房
        
        [mArr addObjectsFromArray:kHouseStatus];
    }
    
    self.pickerList = [NSArray arrayWithArray:mArr];
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
        titleLabel.text = @"";
        
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
        
        self.inputTitleLabel = titleLabel;
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
            case 9: {
                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.titleList];
                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[0]];
                [mDict setObject:image forKey:@"image"];
                [mArr replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
                [self setTitleList:[NSArray arrayWithArray:mArr]];
                [self.imageDataDict setObject:image forKey:@"poster"];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
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

- (void)submitInput:(UIButton *)button {
    
    NSInteger index = self.currentRow;
    NSString *selectedTitle = @"";
    
    if (self.currentRow == 5 || self.currentRow == 6) {
        
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        NSInteger selectedRow2 = [self.pickerView selectedRowInComponent:1];
        
        NSString *province = self.provinceList[selectedRow];
        NSString *city = self.cityList[selectedRow][selectedRow2];
        
        if ([province isEqualToString:city]) {
            
            selectedTitle = [NSString stringWithFormat:@"%@", province];
        } else {
            
            selectedTitle = [NSString stringWithFormat:@"%@-%@", province, city];
        }
    } else {
        
        NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
        selectedTitle = self.pickerList[selectedRow];
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self.titleList[index]];
    [mDict setObject:selectedTitle forKey:@"value"];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.titleList];
    [mArr replaceObjectAtIndex:index withObject:[NSDictionary dictionaryWithDictionary:mDict]];
    
    self.titleList = [NSArray arrayWithArray:mArr];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self cancelInput:self.shadeView.gestureRecognizers.firstObject];
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

- (void)keyboardWillShow:(NSNotification *)notification {
    
    float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.signatureTextView.isFirstResponder) {
        
        [UIView animateWithDuration:duration animations:^{
            
            self.tableView.contentOffset = CGPointMake(0, 540);
        } completion:^(BOOL finished) {
            if (finished) {
                self.tableView.scrollEnabled = NO;
            }
        }];
    } else if (self.commentTextView.isFirstResponder) {
        
        [UIView animateWithDuration:duration animations:^{
            
            self.tableView.contentOffset = CGPointMake(0, 700);
        } completion:^(BOOL finished) {
            if (finished) {
                self.tableView.scrollEnabled = NO;
            }
        }];
    } else if (self.currentRow == 1 || self.currentRow == 10) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentRow inSection:0];
        
        [UIView animateWithDuration:duration animations:^{
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } completion:^(BOOL finished) {
            if (finished) {
                self.tableView.scrollEnabled = NO;
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.signatureTextView.isFirstResponder || self.commentTextView.isFirstResponder) {
        
            CGPoint contentOffset = self.tableView.contentOffset;
            CGSize contentSize = self.tableView.contentSize;
            if (contentOffset.y > (contentSize.height - self.tableView.frame.size.height)) {
        
                float duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
                contentOffset.y = (contentSize.height - self.tableView.frame.size.height);
        
                [UIView animateWithDuration:duration animations:^{
        
                    self.tableView.contentOffset = contentOffset;
                } completion:^(BOOL finished) {
                    if (finished) {
                        self.tableView.scrollEnabled = YES;
                    }
                }];
            }
        self.tableView.scrollEnabled = YES;
    } else {
        
        self.tableView.scrollEnabled = YES;
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
                         poster, \
                         nickname, \
                         sex, \
                         height, \
                         date_format(birthday, '%@') age, \
                         residence, \
                         domicile, \
                         house, \
                         education, \
                         unit_nature, \
                         position, \
                         salary, \
                         marital_status, \
                         photos, \
                         signature, \
                         comment \
                     FROM \
                         user \
                     where \
                         userid = %@", @"%Y", self.userid];
    
    // 筛选条件
    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/query.html"];
    NSDictionary *parameterDict = @{ @"sql": sql };
    
    //获取网络数据
    [HttpUtil query:url parameter:parameterDict success:^(id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = responseDict[@"list"];
        
        NSLog(@"*** success %@ ***", responseDict);
        
        if (array.count == 1) {
            
            NSDictionary *dict = array[0];
            
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.titleList];
            NSMutableDictionary *mDict;
            
            NSString *poster = dict[@"poster"];
            if ([ConversionUtil isNotEmpty:poster]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[0]];
                [mDict setObject:poster forKey:@"value"];
                
                [mArr replaceObjectAtIndex:0 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *nickname = dict[@"nickname"];
            if ([ConversionUtil isNotEmpty:nickname]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[1]];
                [mDict setObject:nickname forKey:@"value"];
                
                [mArr replaceObjectAtIndex:1 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *sex = dict[@"sex"];
            if ([ConversionUtil isNotEmpty:sex]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[2]];
                [mDict setObject:sex forKey:@"value"];
                
                [mArr replaceObjectAtIndex:2 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *height = dict[@"height"];
            if ([ConversionUtil isNotEmpty:height]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[3]];
                [mDict setObject:[height stringByAppendingString:@"cm"] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:3 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *age = dict[@"age"];
            if ([ConversionUtil isNotEmpty:age]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[4]];
                [mDict setObject:[age stringByAppendingString:@"年"] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:4 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *residence = dict[@"residence"];
            if ([ConversionUtil isNotEmpty:residence]) {
                
                NSArray *arr = [residence componentsSeparatedByString:@"-"];
                if (arr.count == 2) {

                    mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[5]];
                    if ([arr[0] isEqualToString:arr[1]]) {
                        
                        [mDict setObject:arr[0] forKey:@"value"];
                    } else {

                        [mDict setObject:[NSString stringWithFormat:@"%@-%@", arr[0], arr[1]] forKey:@"value"];
                    }
                    [mArr replaceObjectAtIndex:5 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
                }
            }
            
            NSString *domicile = dict[@"domicile"];
            if ([ConversionUtil isNotEmpty:domicile]) {
                
                NSArray *arr = [domicile componentsSeparatedByString:@"-"];
                if (arr.count == 2) {
                    
                    mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[6]];
                    if ([arr[0] isEqualToString:arr[1]]) {
                        
                        [mDict setObject:arr[0] forKey:@"value"];
                    } else {
                        
                        [mDict setObject:[NSString stringWithFormat:@"%@-%@", arr[0], arr[1]] forKey:@"value"];
                    }
                    [mArr replaceObjectAtIndex:6 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
                }
            }
            
            NSString *house = dict[@"house"];
            if ([ConversionUtil isNotEmpty:house]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[7]];
                [mDict setObject:kHouseStatus[house.intValue - 1] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:7 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *education = dict[@"education"];
            if ([ConversionUtil isNotEmpty:education]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[8]];
                [mDict setObject:kEducation[education.intValue - 1] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:8 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *unit_nature = dict[@"unit_nature"];
            if ([ConversionUtil isNotEmpty:unit_nature]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[9]];
                [mDict setObject:kUnitNature[unit_nature.intValue - 1] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:9 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *position = dict[@"position"];
            if ([ConversionUtil isNotEmpty:position]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[10]];
                [mDict setObject:position forKey:@"value"];
                
                [mArr replaceObjectAtIndex:10 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *salary = dict[@"salary"];
            if ([ConversionUtil isNotEmpty:salary]) {
                
                if ([salary isEqualToString:@"2000"]) {
                    salary = @"3000以下";
                } else {
                    salary = [NSString stringWithFormat:@"%@以上", salary];
                }
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[11]];
                [mDict setObject:salary forKey:@"value"];
                
                [mArr replaceObjectAtIndex:11 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }
            
            NSString *marital_status = dict[@"marital_status"];
            if ([ConversionUtil isNotEmpty:marital_status]) {
                
                mDict = [NSMutableDictionary dictionaryWithDictionary:mArr[12]];
                [mDict setObject:kMaritalStatus[marital_status.intValue - 1] forKey:@"value"];
                
                [mArr replaceObjectAtIndex:12 withObject:[NSDictionary dictionaryWithDictionary:mDict]];
            }

            if ([ConversionUtil isNotEmpty:dict[@"photos"]]) {
                
                NSArray *imageList = [dict[@"photos"] componentsSeparatedByString:@","];
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
            
            self.signatureTextView.text = dict[@"signature"];
            self.commentTextView.text = dict[@"comment"];
            
            _titleList = [NSArray arrayWithArray:mArr];
        }
        
        [self.tableView reloadData];
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    } failure:^(NSError *error) {
        
        NSLog(@"*** failure %@ ***", error.description);
        
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
    }];
}

- (void)publish:(UIButton *)button {
    
//    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:activityIndicatorView];
//    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
//    [activityIndicatorView startAnimating];
//    
//    UIImage *image1 = [self.imageDataDict objectForKey:@"image1"];
//    UIImage *image2 = [self.imageDataDict objectForKey:@"image2"];
//    UIImage *image3 = [self.imageDataDict objectForKey:@"image3"];
//    
//    NSString *image1Key;
//    NSString *image2Key;
//    NSString *image3Key;
//    
//    if (image1) {
//        
//        NSData *imageData = UIImageJPEGRepresentation(image1, 0.9);
//        image1Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
//        
//        [QiniuUtil upload:imageData key:image1Key];
//        
//        [self.images_address replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image1Key]];
//    }
//    if (image2) {
//        
//        NSData *imageData = UIImageJPEGRepresentation(image2, 0.9);
//        image2Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
//        
//        [QiniuUtil upload:imageData key:image2Key];
//        
//        [self.images_address replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image2Key]];
//    }
//    if (image3) {
//        
//        NSData *imageData = UIImageJPEGRepresentation(image3, 0.9);
//        image3Key = [ConversionUtil stringFromDate:[NSDate date] dateFormat:@"yyyyMMddHHmmssSSS"];
//        
//        [QiniuUtil upload:imageData key:image3Key];
//        
//        [self.images_address replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"http://oqauefc7p.bkt.clouddn.com/%@", image3Key]];
//    }
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@", kDomain, @"manager/save.html"];
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    
//    [parameter setObject:@"user" forKey:@"table"];
//    [parameter setObject:self.userid forKey:@"userid"];
//    [parameter setValue:[NSString stringWithFormat:@"id is null and userid = '%@' ", self.userid] forKey:@"id"];
//    [parameter setObject:self.userid forKey:@"updateUser"];
//    
//    [parameter setObject:self.optionValueList[0] forKey:@"important"];
//    [parameter setObject:self.optionValueList[1] forKey:@"father_job"];
//    [parameter setObject:self.optionValueList[2] forKey:@"mother_job"];
//    
//    [parameter setObject:[self.images_address componentsJoinedByString:@","] forKey:@"images_address"];
//    
//    NSString *text = [self.dadTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    [parameter setObject:text forKey:@"father_comment"];
//    
//    text = [self.mumTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    [parameter setObject:text forKey:@"mother_comment"];
//    
//    text = [self.cityTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    [parameter setObject:text forKey:@"address"];
//    
//    text = [self.streetTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    [parameter setObject:text forKey:@"address_comment"];
//    
//    NSLog(@"*** parameter %@ ***", parameter);
//    
//    [HttpUtil query:url parameter:parameter success:^(id responseObject) {
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"*** success %@ ***", responseDict);
//        
//        if ([responseDict[@"code"] isEqualToString:@"0"]) {
//            
//            [SVProgressHUD showImage:nil status:@"提交成功"];
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//            [SVProgressHUD dismissWithDelay:1.0];
//            
//            [activityIndicatorView stopAnimating];
//            [activityIndicatorView removeFromSuperview];
//        } else {
//            
//            [activityIndicatorView stopAnimating];
//            [activityIndicatorView removeFromSuperview];
//            
//            [SVProgressHUD showImage:nil status:@"提交失败"];
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//            [SVProgressHUD dismissWithDelay:1.5];
//        }
//    } failure:^(NSError *error) {
//        
//        NSLog(@"*** failure %@ ***", error.description);
//        
//        [activityIndicatorView stopAnimating];
//        [activityIndicatorView removeFromSuperview];
//        
//        [SVProgressHUD showImage:nil status:@"提交失败"];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD dismissWithDelay:1.5];
//    }];
}

@end
