//
//  NSString+Utils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (NSDictionary *)convertJson
{
    NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    return nil;
}

@end
