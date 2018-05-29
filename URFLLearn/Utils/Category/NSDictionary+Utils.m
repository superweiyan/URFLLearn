//
//  NSDictionary+Utils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/29.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "NSDictionary+Utils.h"

id bs_safe_get(NSDictionary *dic, Class cls, id key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id val = [dic objectForKey:key];
    if ([val isKindOfClass:cls]) {
        return val;
    }
    return nil;
}


@implementation NSDictionary (Utils)

- (NSString *)URGetString:(id)key
{
    return bs_safe_get(self, [NSString class], key);
}

- (NSAttributedString *)URGetAttributedString:(id)key
{
    return bs_safe_get(self, [NSAttributedString class], key);
}

- (NSNumber *)URGetNumber:(id)key
{
    return bs_safe_get(self, [NSNumber class], key);
}

- (NSArray *)URGetArray:(id)key
{
    return bs_safe_get(self, [NSArray class], key);
}

- (NSDictionary *)URGetDic:(id)key
{
    return bs_safe_get(self, [NSDictionary class], key);
}

@end
