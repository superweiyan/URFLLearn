//
//  URPathConfig.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/5.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URPathConfig.h"

@implementation URPathConfig

+ (void)initDefaultDir
{
    [self checkDownloadCachePath];
    [self checkELFLession];
}

+ (void)checkDownloadCachePath
{
    NSString *downloadCachePath = [self getCacheDirectory];
    downloadCachePath = [downloadCachePath stringByAppendingPathComponent:@"download"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadCachePath
                                  withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)checkELFLession
{
    NSString *downloadCachePath = [self getCacheDirectory];
    downloadCachePath = [downloadCachePath stringByAppendingPathComponent:@"ELF"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadCachePath
                                  withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString *)getHomeDirectory
{
    return NSHomeDirectory();
}

+ (NSString *)getDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)getLibraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)getTmpDirectory
{
    return NSTemporaryDirectory();
}

@end
