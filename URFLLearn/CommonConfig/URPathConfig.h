//
//  URPathConfig.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/5.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URPathConfig : NSObject

+ (void)initDefaultDir;

//沙盒路径
+ (NSString *)getHomeDirectory;

// 获取Documents目录路径
+ (NSString *)getDirectory;

//获取Library的目录路径
+ (NSString *)getLibraryDirectory;

// 获取Caches目录路径
+ (NSString *)getCacheDirectory;

// 获取tmp目录路径
+ (NSString *)getTmpDirectory;
@end
