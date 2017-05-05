//
//  UserModel.m
//  3025
//
//  Created by ld on 2017/3/28.
//
//

#import "UserModel.h"
#import "MJExtension.h"

#define kPlaceholder @"未填写"
#define kEducations @[@"初中",@"高中",@"大专",@"本科",@"硕士",@"博士"]

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
                case 1:
                    _unit_nature = @"政府机关";
                    break;
                case 2:
                    _unit_nature = @"事业单位";
                    break;
                case 3:
                    _unit_nature = @"外企";
                    break;
                case 4:
                    _unit_nature = @"国企";
                    break;
                case 5:
                    _unit_nature = @"私企";
                    break;
                case 6:
                    _unit_nature = @"自己创业";
                    break;
                case 7:
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
        _unitNature = kPlaceholder;
    }
    return _unitNature;
}

- (NSString *)position {
    if ([self.unitNature isEqualToString:kPlaceholder]) {
        _position = @"";
    }
    return _position;
}

- (NSString *)domicile {
    if (!_domicile) {
        _domicile = kPlaceholder;
    } else {
        if ([_domicile containsString:@"-"]) {
            NSArray *arr = [_domicile componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                if ([arr[0] isEqualToString:arr[1]]) {
                    _domicile = [NSString stringWithFormat:@"%@市", arr[0]];
                } else {
                    _domicile = [NSString stringWithFormat:@"%@省%@市", arr[0], arr[1]];
                }
            }
        }
    }
    return _domicile;
}

- (NSString *)residence {
    if (!_residence) {
        _residence = kPlaceholder;
    } else {
        if ([_residence containsString:@"-"]) {
            NSArray *arr = [_residence componentsSeparatedByString:@"-"];
            if (arr.count == 2) {
                if ([arr[0] isEqualToString:arr[1]]) {
                    _residence = [NSString stringWithFormat:@"%@市", arr[0]];
                } else {
                    _residence = [NSString stringWithFormat:@"%@省%@市", arr[0], arr[1]];
                }
            }
        }
    }
    return _residence;
}

- (NSString *)birthday {
    if (!_birthday) {
        _birthday = [NSString stringWithFormat:@"年龄%@", kPlaceholder];
    } else {
        if (![_birthday containsString:@"年"]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy年";
            _birthday = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_birthday integerValue]/1000]];
        }
    }
    return _birthday;
}

- (NSString *)height {
    if (!_height) {
        _height = [NSString stringWithFormat:@"身高%@", kPlaceholder];
    } else {
        if (![_height containsString:@"cm"]) {
            _height = [NSString stringWithFormat:@"%@cm", _height];
        }
    }
    return _height;
}

- (NSString *)education {
    if (!_education) {
        _education = [NSString stringWithFormat:@"学历%@", kPlaceholder];
    } else {
        if ([_education containsString:@"0"]) {
            _education = kEducations[[_education intValue]-1];
        }
    }
    return _education;
}

- (NSString *)condition {
    if (!_condition) {
        if (self.conditionAge || self.conditionDomicile) {
            _condition = @"";
        }
    }
    return _condition;
}

- (NSString *)conditionDomicile {
    if ([_conditionDomicile containsString:@"不限"]) {
        _conditionDomicile = @"不限";
    } else if ([_conditionDomicile containsString:@"-"]) {
        NSArray *arr = [_conditionDomicile componentsSeparatedByString:@"-"];
        if (arr.count == 2) {
            if ([arr[0] isEqualToString:arr[1]]) {
                _conditionDomicile = [NSString stringWithFormat:@"%@市", arr[0]];
            } else {
                _conditionDomicile = [NSString stringWithFormat:@"%@省%@市", arr[0], arr[1]];
            }
        }
    }
    return _conditionDomicile;
}

- (NSString *)conditionAge {
    if ([_conditionAge containsString:@"年"]) {
        
    } else if ([_conditionAge containsString:@"-"]) {
        NSArray *arr = [_conditionAge componentsSeparatedByString:@"-"];
        if (arr.count == 2) {
            if ([arr[0] isEqualToString:@"0"] && [arr[1] isEqualToString:@"0"]) {
                _conditionAge = @"年龄不限";
            } else if ([arr[0] isEqualToString:@"0"] && ![arr[1] isEqualToString:@"0"]) {
                _conditionAge = [NSString stringWithFormat:@"不限-%@年", [arr[1] substringFromIndex:2]];
            } else if (![arr[0] isEqualToString:@"0"] && [arr[1] isEqualToString:@"0"]) {
                _conditionAge = [NSString stringWithFormat:@"%@年-不限", [arr[0] substringFromIndex:2]];
            } else {
                _conditionAge = [NSString stringWithFormat:@"%@年-%@年", [arr[0] substringFromIndex:2], [arr[1] substringFromIndex:2]];
            }
        }
    }
    return _conditionAge;
}

@end
