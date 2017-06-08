//
//  PropertyCell.h
//  3025
//
//  Created by ld on 2017/6/8.
//
//

#import <UIKit/UIKit.h>

@class PropertyCell;

@protocol PropertyCellDelegate <NSObject>

@required
- (void)input:(NSIndexPath *)indexPath;
- (void)inputComplete:(NSString *)text;

@end

@interface PropertyCell : UITableViewCell

@property (nonatomic, assign) BOOL multi;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<PropertyCellDelegate> delegate;

- (void)setupData:(NSDictionary *)dict;

@end
