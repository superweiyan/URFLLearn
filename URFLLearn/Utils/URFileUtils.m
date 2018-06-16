//
//  URFileUtils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/16.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URFileUtils.h"

@implementation URFileUtils

+ (NSString *)getDocumentDir
{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return [docPath objectAtIndex:0];
}

+ (NSString *)getCacheDir
{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [cacPath objectAtIndex:0];
}

+ (NSString *)getLibraryDir
{
    NSArray *libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [libsPath objectAtIndex:0];
}

+ (NSString *)getTempDir
{
    return NSTemporaryDirectory();
}

@end
