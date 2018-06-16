//
//  URFileUtils.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/16.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URFileUtils : NSObject

+ (NSString *)getDocumentDir;
+ (NSString *)getCacheDir;
+ (NSString *)getLibraryDir;
+ (NSString *)getTempDir;

@end
