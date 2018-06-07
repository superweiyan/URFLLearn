//
//  NSObject+modelHeight.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/7.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "NSObject+modelHeight.h"
#import <objc/runtime.h>

static NSString *objectModelHeightKey = @"objectModelHeightKey";

@implementation NSObject (modelHeight)

- (void)setModelHeight:(CGFloat)modelHeight
{
    objc_setAssociatedObject(self, &objectModelHeightKey, @(modelHeight), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)modelHeight
{
    NSNumber *value = objc_getAssociatedObject(self, &objectModelHeightKey);
    return value.floatValue;
}

@end
