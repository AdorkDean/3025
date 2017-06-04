//
//  BlockCell.m
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import "BlockCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"

@interface BlockCell () {
    
}

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nicknameLable;
@property (nonatomic, strong) UILabel *idLable;
@property (nonatomic, strong) UILabel *careerLable;
@property (nonatomic, strong) UILabel *introLable;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *expectionLable;
@property (nonatomic, strong) UILabel *detailLable;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation BlockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.posterImageView = [[UIImageView alloc] init];
    self.posterImageView.contentMode = UIViewContentModeScaleToFill;
    self.posterImageView.layer.borderColor = kKeyColor.CGColor;
    self.posterImageView.layer.borderWidth = 1.0;
    self.posterImageView.layer.cornerRadius = 25.0;
    self.posterImageView.layer.masksToBounds = YES;
    
    self.nicknameLable = [[UILabel alloc] init];
    self.nicknameLable.textColor = [UIColor blackColor];
    self.nicknameLable.font = [UIFont systemFontOfSize:14.0f];
    self.nicknameLable.numberOfLines = 1;
    
    self.idLable = [[UILabel alloc] init];
    self.idLable.textColor = kKeyColor;
    self.idLable.font = [UIFont systemFontOfSize:14.0f];
    self.idLable.numberOfLines = 1;
    
    self.careerLable = [[UILabel alloc] init];
    self.careerLable.textColor = [UIColor blackColor];
    self.careerLable.font = [UIFont systemFontOfSize:14.0f];
    self.careerLable.numberOfLines = 1;
    
    self.introLable = [[UILabel alloc] init];
    self.introLable.textColor = [UIColor grayColor];
    self.introLable.font = [UIFont systemFontOfSize:12.0f];
    self.introLable.numberOfLines = 0;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    
    self.expectionLable = [[UILabel alloc] init];
    self.expectionLable.textAlignment = NSTextAlignmentCenter;
    self.expectionLable.textColor = [UIColor blackColor];
    self.expectionLable.font = [UIFont systemFontOfSize:12.0f];
    self.expectionLable.numberOfLines = 1;
    self.expectionLable.layer.borderColor = kLineColor.CGColor;
    self.expectionLable.layer.borderWidth = 1.0;
    self.expectionLable.layer.cornerRadius = 5.0;
    
    self.detailLable = [[UILabel alloc] init];
    self.detailLable.textColor = [UIColor grayColor];
    self.detailLable.font = [UIFont systemFontOfSize:12.0f];
    self.detailLable.numberOfLines = 1;
    
    self.arrowImageView = [[UIImageView alloc] init];
    self.arrowImageView.contentMode = UIViewContentModeScaleToFill;
    self.arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    [self.contentView addSubview:self.posterImageView];
    [self.contentView addSubview:self.nicknameLable];
    [self.contentView addSubview:self.idLable];
    [self.contentView addSubview:self.careerLable];
    [self.contentView addSubview:self.introLable];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.expectionLable];
    [self.contentView addSubview:self.detailLable];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    [self.nicknameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.posterImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.posterImageView);
        make.width.height.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.idLable setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.idLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.nicknameLable.mas_right).offset(10).priority(MASLayoutPriorityRequired);
        make.top.mas_equalTo(self.posterImageView);
        make.right.mas_equalTo(self.contentView).offset(-10).priority(MASLayoutPriorityRequired);
    }];
    [self.careerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nicknameLable);
        make.top.mas_equalTo(self.nicknameLable.mas_bottom).offset(2.5);
        make.right.mas_equalTo(self.idLable);
    }];
    // 一定要设定preferredMaxLayoutWidth，不然计算不正确
    self.introLable.preferredMaxLayoutWidth = kScreenWidth - 80; // kScreenWidth = 10 + 50 + 10 + preferredMaxLayoutWidth + 10
    [self.introLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nicknameLable);
        make.top.mas_equalTo(self.careerLable.mas_bottom).offset(5);
        make.right.mas_equalTo(self.idLable);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.introLable.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    [self.expectionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.posterImageView);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(0);
        make.centerY.mas_equalTo(self.expectionLable);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.idLable);
        make.centerY.mas_equalTo(self.expectionLable);
        make.width.height.mas_equalTo(15);
    }];
}

- (void)setupData:(BlockModel *)model {
    
    // 用户头像
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:model.poster] placeholderImage:[UIImage imageNamed:@"poster"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    // 用户昵称
    [self.nicknameLable setText:[NSString stringWithFormat:@"%@", model.nickname]];
    // 用户ID
    [self.idLable setText:[NSString stringWithFormat:@"ID: %@", model.userid]];
    // 用户职业
    [self.careerLable setText:[NSString stringWithFormat:@"职业: %@ %@", model.unitNature, model.position]];
    // 用户简介
    NSString *intro = [NSString stringWithFormat:@"%@, 现居%@, 户籍%@, %@, %@, %@", model.sex, model.residence, model.domicile, model.birthday, model.height, model.education];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:intro attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    [self.introLable setAttributedText:attributedString];
    // 择偶标准
    [self.expectionLable setText:@"移除黑名单"];
    // 查看详情
    [self.detailLable setText:@"查看详情"];
}

@end
