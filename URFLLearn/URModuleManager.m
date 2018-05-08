//
//  URModuleManager.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/5.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URModuleManager.h"
#import "EFLModule.h"
#import "URUniqueManager.h"

@implementation URModuleManager

+ (instancetype)sharedObject
{
    static dispatch_once_t __once;              \
    static URModuleManager * __instance = nil;         \
    dispatch_once(&__once, ^{                   \
        __instance = [[URModuleManager alloc] init];   \
    });                                         \
    return __instance;
//    http://makefriends.bs2dl.yy.com/EFL01.zip
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.eFLModule = [[EFLModule alloc] init];
        self.uniqueManager = [[URUniqueManager alloc] init];
    }
    return self;
}
@end
