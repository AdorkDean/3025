//
//  MomentCell.h
//  3025
//
//  Created by ld on 2017/5/27.
//
//

#import <UIKit/UIKit.h>
#import "MomentModel.h"

@protocol MomentCellDelegate <NSObject>

@required
- (void)showContent:(UIEvent *)event;
- (void)showImages:(NSUInteger)currentIndex gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (void)deleteMoment:(UIEvent *)event;

@end

@interface MomentCell : UITableViewCell

@property (nonatomic, assign) BOOL isExtend;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, weak) id<MomentCellDelegate> delegate;

- (void)setupData:(MomentModel *)momentModel;

@end
