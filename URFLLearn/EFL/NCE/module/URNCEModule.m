//
//  URNCEModule.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/15.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEModule.h"
#import "URDownloadFileUtils.h"
#import "URNCEType.h"
#import "NSString+Utils.h"
#import "URFileUtils.h"
#import "SSZipArchive.h"
#import "URCommonMarco.h"

@interface URNCEModule()<SSZipArchiveDelegate>

@property (nonatomic, strong) NSMutableDictionary *urlHashDict;

@end


@implementation URNCEModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlHashDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)downloadFileForUrl:(NSString *)url dest:(NSString *)dest completeHandler:(void (^)(void))completeHandler
{
    NSString *hashValue = [self getHashName:dest];
    NSString *path = [[URFileUtils getCacheDir] stringByAppendingPathComponent:hashValue];
    
    [[URDownloadFileUtils sharedObject] downloadFile:url dest:[NSURL fileURLWithPath:path] progress:^(CGFloat progress) {
        
    } completionHandler:^(NSString *filePath){
        
    }];
}

- (void)downloadFileForUrl:(NSString *)url
{
    WeakSelf
    [[URDownloadFileUtils sharedObject] downloadFile:url dest:nil progress:^(CGFloat progress) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{@"url":url, @"progress":@(progress)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:userInfo];
        });
        
    } completionHandler:^(NSString *filePath) {
        [weakSelf upzipFile:filePath url:url] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadFileFinishNotification object:nil];
    }];
}

- (void)upzipFile:(NSString *)filePath url:(NSString *)url
{
    NSString *hashValue = [self getHashName:url];
    NSString *hashPath = [[URFileUtils getCacheDir] stringByAppendingPathComponent:hashValue];
    
    NSString *zipFileName = filePath.lastPathComponent;
    NSString *lastComponent = zipFileName.stringByDeletingPathExtension;
    NSString *zipFullPath = [[URFileUtils getCacheDir] stringByAppendingPathComponent:lastComponent];
    
    if([SSZipArchive unzipFileAtPath:filePath
                       toDestination:[URFileUtils getCacheDir]
                     progressHandler:nil
                   completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                       
                       if (succeeded) {
                           [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                           [[NSFileManager defaultManager] moveItemAtPath:zipFullPath toPath:hashPath error:nil];
                       }
                       else {
                           
                       }
        
    }])
    {
    }
    
    
}

- (BOOL)checkDownloadFile:(NSString *)url
{
    NSString *hashFile = [self getHashName:url];
    if (hashFile.length == 0) {
        return NO;
    }
    
    BOOL isDirectory = YES;
    if([[NSFileManager defaultManager] fileExistsAtPath:hashFile isDirectory:&isDirectory] ) {
        return YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:hashFile]) {
        NSString *destDir = [[URFileUtils getCacheDir] stringByAppendingPathComponent:hashFile];
        [SSZipArchive unzipFileAtPath:hashFile toDestination:destDir];
    }
    
    return NO;
}

- (BOOL)hadDownloadedFile:(NSString *)url
{
    NSString *hashFile = [self getHashName:url];
    NSString *filePath = [[URFileUtils getCacheDir] stringByAppendingPathComponent:hashFile];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

- (NSString *)getHashName:(NSString *)url
{
    NSString *hashInfo = [self.urlHashDict objectForKey:url];
    if (hashInfo.length > 0) {
        return hashInfo;
    }
    
    NSString *hashValue = [url md5String];
    [self.urlHashDict setObject:hashValue forKey:url];
    return hashValue;
}
        
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath
{
    NSLog(@"+++ %@, %@", path, unzippedPath);
}

@end
