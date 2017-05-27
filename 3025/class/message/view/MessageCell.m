//
//  MessageCell.m
//  3025
//
//  Created by WangErdong on 2017/5/3.
//
//

#import "MessageCell.h"
#import "Constant.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MessageCell () {

}

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *badgeNumberLabel;

@end

@implementation MessageCell

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
    posterImageView.layer.cornerRadius = 20;
    posterImageView.layer.masksToBounds = YES;
    
    UILabel *nicknameLabel = [[UILabel alloc] init];
    nicknameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    nicknameLabel.textColor = [UIColor blackColor];
    nicknameLabel.numberOfLines = 1;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textColor = [UIColor grayColor];
    [timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:12.0f];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.numberOfLines = 1;
    
    UILabel *badgeNumberLabel = [[UILabel alloc] init];
    badgeNumberLabel.backgroundColor = [UIColor redColor];
    badgeNumberLabel.layer.cornerRadius = 5;
    badgeNumberLabel.layer.masksToBounds = YES;
    badgeNumberLabel.font = [UIFont systemFontOfSize:12.0f];
    badgeNumberLabel.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:posterImageView];
    [self.contentView addSubview:nicknameLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:badgeNumberLabel];
    
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).mas_offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(posterImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(posterImageView);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(timeLabel.mas_left).mas_offset(-10);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-10).priorityHigh();
        make.centerY.height.mas_equalTo(nicknameLabel);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nicknameLabel);
        make.top.mas_equalTo(nicknameLabel.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(self.contentView).mas_offset(-10);
    }];
    [badgeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(posterImageView.mas_right);
        make.centerY.mas_equalTo(posterImageView.mas_top);
        make.width.height.mas_equalTo(10);
    }];
    
    self.posterImageView = posterImageView;
    self.nicknameLabel = nicknameLabel;
    self.timeLabel = timeLabel;
    self.contentLabel = contentLabel;
    self.badgeNumberLabel = badgeNumberLabel;
}

- (void)setupData:(MessageModel *)messageModel {
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.other_poster] placeholderImage:[UIImage imageNamed:@"poster"]];
    
    self.nicknameLabel.text = messageModel.other_nickname;
    
    self.timeLabel.text = messageModel.createtime;
    
    self.contentLabel.text = messageModel.content;
    
    self.badgeNumberLabel.hidden = ![messageModel.status isEqualToString:@"0"];
}

@end
