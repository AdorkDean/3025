//
//  ActivityModel.h
//  3025
//
//  Created by ld on 2017/4/25.
//
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "UserModel.h"

@interface ActivityModel : NSObject

@property (nonatomic, copy) NSString *activityid;
@property (nonatomic, copy) NSString *activityname;
@property (nonatomic, copy) NSString *capacityTo;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *match100;
@property (nonatomic, copy) NSString *match90;
@property (nonatomic, copy) NSString *match80;
@property (nonatomic, strong) UserModel *user;

@property (nonatomic, copy) NSString *poster;
@property (nonatomic, assign) BOOL hasTa;
@property (nonatomic, copy) NSString *location;

@end
