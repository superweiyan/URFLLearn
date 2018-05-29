//
//  URModuleManager.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/5.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UREFLDialogueModule;
@class URUniqueManager;

@interface URModuleManager : NSObject

@property (nonatomic, strong) UREFLDialogueModule       *eFLDialogueModule;
@property (nonatomic, strong) URUniqueManager           *uniqueManager;

+ (instancetype)sharedObject;

@end
