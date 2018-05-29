//
//  NSDictionary+Utils.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/29.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

- (NSString *)URGetString:(id)key;
- (NSAttributedString *)URGetAttributedString:(id)key;
- (NSNumber *)URGetNumber:(id)key;
- (NSArray *)URGetArray:(id)key;
- (NSDictionary *)URGetDic:(id)key;

@end
