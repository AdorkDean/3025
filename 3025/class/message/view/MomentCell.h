//
//  MomentCell.h
//  3025
//
//  Created by ld on 2017/5/27.
//
//

#import <UIKit/UIKit.h>
#import "MomentModel.h"

@interface MomentCell : UITableViewCell

@property (nonatomic, assign) BOOL isExtend;
@property (nonatomic, assign) BOOL isMine;

- (void)setupData:(MomentModel *)momentModel;

@end
