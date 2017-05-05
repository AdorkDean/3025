//
//  ActivityModel.m
//  3025
//
//  Created by ld on 2017/4/25.
//
//

#import "ActivityModel.h"
#import "ConversionUtil.h"

@implementation ActivityModel

- (NSString *)poster {
    if (!_poster) {
        _poster = self.user.poster;
    }
    return _poster;
}

- (BOOL)hasTa {
    return ([self.match100 intValue] + [self.match90 intValue] + [self.match80 intValue] > 0);
}

- (NSString *)location {
    if (!_location) {
        if ([self.province isEqualToString:self.city]) {
            _location = [NSString stringWithFormat:@"%@ %@", self.city, self.district];
        } else {
            _location = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.district];
        }
    }
    return _location;
}

- (NSString *)category {
    if ([_category hasPrefix:@"0"]) {
        _category = [ConversionUtil activityCategory:_category];
    }
    return _category;
}

@end
