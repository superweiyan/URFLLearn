//
//  URModuleManager.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/5.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URModuleManager.h"
#import "UREFLDialogueModule.h"
#import "URUniqueManager.h"
#import "URNCEModule.h"

@interface URModuleManager()

@property (nonatomic, strong) NSMutableDictionary *moduleDict;

@end

@implementation URModuleManager

+ (instancetype)sharedObject
{
    static dispatch_once_t __once;
    static URModuleManager * __instance = nil;
    dispatch_once(&__once, ^{
        __instance = [[URModuleManager alloc] init];
    });                                         
    return __instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.moduleDict = [[NSMutableDictionary alloc] init];
        
        self.eFLDialogueModule = [[UREFLDialogueModule alloc] init];
        self.uniqueManager = [[URUniqueManager alloc] init];
        self.nceModule = [[URNCEModule alloc] init];
        
        [self registerModule:@"EFLModule"];
    }
    return self;
}

- (void)registerModule:(NSString *)key
{
    id obj = [[NSClassFromString(key) alloc] init];
    [self.moduleDict setObject:obj forKey:key];
}

@end
