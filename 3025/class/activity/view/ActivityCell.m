//
//  ActivityCell.m
//  3025
//
//  Created by ld on 2017/4/21.
//
//

#import "ActivityCell.h"
#import "Constant.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface ActivityCell () {

}

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *capacityLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *taLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.contentMode = UIViewContentModeScaleToFill;
    posterImageView.layer.borderColor = kKeyColor.CGColor;
    posterImageView.layer.borderWidth = 1;
    posterImageView.layer.cornerRadius = 5;
    posterImageView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 1;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.contentMode = UIViewContentModeScaleToFill;
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    UILabel *capacityLabel = [[UILabel alloc] init];
    capacityLabel.layer.borderColor = [UIColor colorWithRed:228.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f].CGColor;
    capacityLabel.layer.borderWidth = 1;
    capacityLabel.layer.cornerRadius = 4;
    capacityLabel.font = [UIFont systemFontOfSize:14.0f];
    capacityLabel.textColor = [UIColor colorWithRed:228.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1.0f];
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.layer.borderColor = [UIColor colorWithRed:65.0f/255.0f green:117.0f/255.0f blue:5.0f/255.0f alpha:1.0f].CGColor;
    categoryLabel.layer.borderWidth = 1;
    categoryLabel.layer.cornerRadius = 4;
    categoryLabel.font = [UIFont systemFontOfSize:14.0f];
    categoryLabel.textColor = [UIColor colorWithRed:65.0f/255.0f green:117.0f/255.0f blue:5.0f/255.0f alpha:1.0f];
    
    UILabel *taLabel = [[UILabel alloc] init];
    taLabel.layer.borderColor = [UIColor colorWithRed:74.0f/255.0f green:114.0f/255.0f blue:226.0f/255.0f alpha:1.0f].CGColor;
    taLabel.layer.borderWidth = 1;
    taLabel.layer.cornerRadius = 4;
    taLabel.font = [UIFont systemFontOfSize:14.0f];
    taLabel.textColor = [UIColor colorWithRed:74.0f/255.0f green:114.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
    taLabel.text = @" 有TA ";
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:14.0f];
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.numberOfLines = 3;
    detailLabel.preferredMaxLayoutWidth = (kScreenWidth - 90);
    
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.font = [UIFont systemFontOfSize:14.0f];
    locationLabel.textColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:posterImageView];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:arrowImageView];
    [self.contentView addSubview:capacityLabel];
    [self.contentView addSubview:categoryLabel];
    [self.contentView addSubview:taLabel];
    [self.contentView addSubview:detailLabel];
    [self.contentView addSubview:locationLabel];
    
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).mas_offset(10);
        make.width.height.mas_equalTo(60);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(posterImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(posterImageView);
        make.right.mas_equalTo(arrowImageView.mas_left).mas_offset(-10);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-10).priorityHigh();
        make.centerY.mas_equalTo(titleLabel);
        make.width.height.mas_equalTo(20);
    }];
    [capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(5);
    }];
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(capacityLabel.mas_right).mas_offset(5);
        make.top.height.mas_equalTo(capacityLabel);
    }];
    [taLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(categoryLabel.mas_right).mas_offset(5);
        make.top.height.mas_equalTo(capacityLabel);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(capacityLabel.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(arrowImageView);
    }];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowImageView);
        make.top.mas_equalTo(detailLabel.mas_bottom).mas_offset(5);
        make.bottom.mas_equalTo(self.contentView).mas_equalTo(-10);
    }];
    
    self.posterImageView = posterImageView;
    self.titleLabel = titleLabel;
    self.capacityLabel = capacityLabel;
    self.categoryLabel = categoryLabel;
    self.taLabel = taLabel;
    self.detailLabel = detailLabel;
    self.locationLabel = locationLabel;
}

- (void)setupData:(NSDictionary *)dict {
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"user"][@"poster"]] placeholderImage:[UIImage imageNamed:@"activity_poster"]];
    
    self.titleLabel.text = dict[@"activityname"];
    
    self.capacityLabel.text = [NSString stringWithFormat:@" %@人 ", dict[@"capacityTo"]];
    
    self.categoryLabel.text = [NSString stringWithFormat:@" %@ ", dict[@"category"]];
    
    self.taLabel.hidden = ([[NSString stringWithFormat:@"%@", dict[@"match100"]] isEqualToString:@"0"]);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:dict[@"content"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    self.locationLabel.text = [NSString stringWithFormat:@"%@ %@", dict[@"city"], dict[@"district"]];
}

@end
