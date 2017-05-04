//
//  MessageCell.h
//  3025
//
//  Created by WangErdong on 2017/5/3.
//
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell

- (void)setupData:(MessageModel *)messageModel;

@end
