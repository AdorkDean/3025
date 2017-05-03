//
//  UserModel.m
//  3025
//
//  Created by ld on 2017/3/28.
//
//

#import "UserModel.h"
#import "MJExtension.h"

@interface UserModel () {
    
}

@end

@implementation UserModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

- (void)setUnit_nature:(NSString *)unit_nature {
    if (unit_nature) {
        @try {
            int num = [unit_nature intValue];
            switch (num) {
                case 0:
                    _unit_nature = @"政府机关";
                    break;
                case 1:
                    _unit_nature = @"事业单位";
                    break;
                case 2:
                    _unit_nature = @"外企";
                    break;
                case 3:
                    _unit_nature = @"国企";
                    break;
                case 4:
                    _unit_nature = @"私企";
                    break;
                case 5:
                    _unit_nature = @"自己创业";
                    break;
                case 6:
                    _unit_nature = @"其他";
                    break;
                default:
                    break;
            }
        } @catch (NSException *exception) {
        }
    }
}

- (NSString *)unitNature {
    if (_unit_nature && !_unitNature) {
        _unitNature = _unit_nature;
    }
    if (!_unitNature && !_position) {
        _unitNature = @"未填写";
    }
    return _unitNature;
}

- (NSString *)position {
    if (!_unitNature && !_position) {
        return @"";
    }
    return _position;
}

@end
