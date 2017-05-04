//
//  MessageModel.h
//  3025
//
//  Created by ld on 2017/5/4.
//
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *other_poster;
@property (nonatomic, copy) NSString *other_nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *withUserid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *me_poster;

@end
