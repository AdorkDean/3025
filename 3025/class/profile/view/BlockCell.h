//
//  BlockCell.h
//  3025
//
//  Created by WangErdong on 2017/6/4.
//
//

#import <UIKit/UIKit.h>
#import "BlockModel.h"

@protocol BlockCellDelegate <NSObject>

@required
- (void)remove:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)detail:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@interface BlockCell : UITableViewCell

@property (nonatomic, weak) id<BlockCellDelegate> delegate;

- (void)setupData:(BlockModel *)model;

@end
