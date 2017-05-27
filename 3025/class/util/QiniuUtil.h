//
//  QiniuUtil.h
//  3025
//
//  Created by ld on 2017/5/24.
//
//

#import <Foundation/Foundation.h>

@interface QiniuUtil : NSObject

/*!
 *    @brief 上传文件到七牛云
 *
 */
+ (void)upload:(NSData *)uploadData key:(NSString *)filename;

@end
