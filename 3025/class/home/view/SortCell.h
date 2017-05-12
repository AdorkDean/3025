//
//  SortCell.h
//  3025
//
//  Created by ld on 2017/5/11.
//
//

#import <UIKit/UIKit.h>

@class SortCell;

@protocol SortCellDelegate <NSObject>

@required
- (void)input:(NSIndexPath *)indexPath multi:(BOOL)multi;

@end

@interface SortCell : UITableViewCell

@property (nonatomic, assign) BOOL multi;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<SortCellDelegate> delegate;

- (void)setupData:(NSDictionary *)dict;

@end
