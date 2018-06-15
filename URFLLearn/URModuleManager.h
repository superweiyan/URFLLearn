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
@class URNCEModule;

@interface URModuleManager : NSObject

@property (nonatomic, strong) UREFLDialogueModule       *eFLDialogueModule;
@property (nonatomic, strong) URUniqueManager           *uniqueManager;
@property (nonatomic, strong) URNCEModule               *nceModule;

+ (instancetype)sharedObject;

@end
