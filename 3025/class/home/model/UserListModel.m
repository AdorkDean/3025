//
//  UserListModel.m
//  3025
//
//  Created by ld on 2017/3/29.
//
//

#import "UserListModel.h"
#import "MJExtension.h"

@implementation UserListModel

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{ @"userList" : @"UserModel" };
}

@end
