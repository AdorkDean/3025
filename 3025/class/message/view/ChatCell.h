//
//  ChatCell.h
//  3025
//
//  Created by WangErdong on 2017/6/3.
//
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

- (void)setupData:(NSDictionary *)msgDict preData:(NSDictionary *)previousDict;

@end
