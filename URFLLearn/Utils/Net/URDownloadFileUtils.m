//
//  URDownloadFileUtils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/13.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URDownloadFileUtils.h"
#import "AFNetworking.h"
#import <objc/runtime.h>
#import "URCommonMarco.h"
#import "URFileUtils.h"

NSString * const DownloadFileProperty = @"downloadFile";
NSString * const DownloadPathProperty = @"path";

@interface URDownloadFileUtils()

@property (nonatomic, strong) NSMutableDictionary *downloadTasksDict;
@end

@implementation URDownloadFileUtils

+ (instancetype)sharedObject
{
    static dispatch_once_t __once;
    static URDownloadFileUtils * __instance = nil;
    dispatch_once(&__once, ^{
        __instance = [[URDownloadFileUtils alloc] init];
    });
    return __instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadTasksDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)downloadFile:(NSString *)url
                dest:(NSURL *)dest
            progress:(void(^)(CGFloat progress))progress
   completionHandler:(void(^)(NSString *filePath))completionHandler
{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURLSessionDownloadTask *downloadTask = nil;
    
    WeakSelf
    NSString *tmpName = [self checkTempFileForUrl:url];
    if (tmpName.length > 0) {
        
        NSData *resumeData = [self newResumeData:tmpName url:url];
        
        downloadTask = [manager downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            
            if (progress) {
                progress(100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            if (dest) {
                return dest;
            }
            
            NSString *path = [[URFileUtils getCacheDir] stringByAppendingPathComponent:@"download"];
            path = [path stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            [weakSelf clearDownloadManager:url];
            
            if(completionHandler) {
                completionHandler([filePath path]);
            }
        }];
    }
    else {
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        downloadTask = [manager downloadTaskWithRequest:req progress:^(NSProgress *downloadProgress){
            
            if (progress) {
                progress(100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            if (dest) {
                return dest;
            }

            NSString *path = [[URFileUtils getCacheDir] stringByAppendingPathComponent:@"download"];
            path = [path stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];

        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            [weakSelf clearDownloadManager:url];
            if (completionHandler) {
                completionHandler([filePath path]);
            }
        }];
        
        if(downloadTask) {
            // 保存
            NSString *tmpPath = [self tempCacheFileNameForTask:downloadTask];
            [[NSUserDefaults standardUserDefaults] setObject:tmpPath forKey:url];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    [downloadTask resume];
    
    [self.downloadTasksDict setObject:manager forKey:url];
}

- (void)removeTmpFile:(NSString *)url
{
    NSString *tmpFileName = [self checkTempFileForUrl:url];
    
    if (tmpFileName.length > 0) {
        NSString *tempPath = NSTemporaryDirectory();
        NSString *tempFile = [tempPath stringByAppendingPathComponent:tmpFileName];
        [[NSFileManager defaultManager] removeItemAtPath:tempFile error:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:url];
    }
}

- (void)clearDownloadManager:(NSString *)url
{
    AFURLSessionManager *manager = [self.downloadTasksDict objectForKey:url];
    if (manager) {
        [manager.session invalidateAndCancel];
    }
}

#pragma mark - utils

- (NSString *)checkTempFileForUrl:(NSString *)url
{
    NSString *tmpName = [[NSUserDefaults standardUserDefaults] objectForKey:url];
    if (tmpName.length > 0) {
        
        NSString *tempPath = NSTemporaryDirectory();
        NSString *tempFile = [tempPath stringByAppendingPathComponent:tmpName];

        if([[NSFileManager defaultManager] fileExistsAtPath:tempFile]){
            return tmpName;
        }
        else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:url];
        }
    }
    return nil;
}

/**
 * @param
 * tmpFileName : 临时文件的名字，也就是一开始缓存的名字
 * url : 原始的下载URL
 */
- (NSData *)newResumeData:(NSString *)tmpFileName url:(NSString *)url
{
    NSString * const DownloadResumeDataLength = @"bytes=%ld-";
    NSString * const DownloadHttpFieldRange = @"Range";
    NSString * const DownloadKeyDownloadURL = @"NSURLSessionDownloadURL";
    NSString * const DownloadTempFilePath = @"NSURLSessionResumeInfoLocalPath";
    NSString * const DownloadKeyBytesReceived = @"NSURLSessionResumeBytesReceived";
    NSString * const DownloadKeyCurrentRequest = @"NSURLSessionResumeCurrentRequest";
    NSString * const DownloadKeyTempFileName = @"NSURLSessionResumeInfoTempFileName";
    
    NSData *resultData = nil;
    
    NSString *tempPath = NSTemporaryDirectory();
    NSString *tempFile = [tempPath stringByAppendingPathComponent:tmpFileName];
    
    NSData *tempCacheData = [NSData dataWithContentsOfFile:tempFile];
    
    if (tempCacheData && tempCacheData.length > 0) {
        NSMutableDictionary *resumeDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableURLRequest *newResumeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [newResumeRequest addValue:[NSString stringWithFormat:DownloadResumeDataLength,(long)(tempCacheData.length)] forHTTPHeaderField:DownloadHttpFieldRange];
        NSData *newResumeRequestData = [NSKeyedArchiver archivedDataWithRootObject:newResumeRequest];
        [resumeDataDict setObject:@(tempCacheData.length) forKey:DownloadKeyBytesReceived];
        [resumeDataDict setObject:newResumeRequestData forKey:DownloadKeyCurrentRequest];
        [resumeDataDict setObject:tmpFileName forKey:DownloadKeyTempFileName];
        [resumeDataDict setObject:url forKey:DownloadKeyDownloadURL];
        [resumeDataDict setObject:tempFile forKey:DownloadTempFilePath];
        resultData = [NSPropertyListSerialization dataWithPropertyList:resumeDataDict format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListImmutable error:nil];
    }
    
    return resultData;
}

//- (NSURL *)getNewPath:(NSString *)name
//{
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
//                                                                          inDomain:NSUserDomainMask
//                                                                 appropriateForURL:nil
//                                                                            create:NO
//                                                                             error:nil];
//
//    NSURL *newUrl = [documentsDirectoryURL URLByAppendingPathComponent:name];
//    NSLog(@"newUrl %@", newUrl.absoluteString);
//    return newUrl;
//}

- (NSString *)tempCacheFileNameForTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSString *resultFileName = nil;
    //拉取属性
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([downloadTask class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
//        NSLog(@"proertyName : %@", propertyName);
        
        if ([DownloadFileProperty isEqualToString:propertyName]) {
            id propertyValue = [downloadTask valueForKey:(NSString *)propertyName];
            unsigned int downloadFileoutCount, downloadFileIndex;
            objc_property_t *downloadFileproperties = class_copyPropertyList([propertyValue class], &downloadFileoutCount);
            for (downloadFileIndex = 0; downloadFileIndex < downloadFileoutCount; downloadFileIndex++) {
                objc_property_t downloadFileproperty = downloadFileproperties[downloadFileIndex];
                const char* downloadFilechar_f = property_getName(downloadFileproperty);
                NSString *downloadFilepropertyName = [NSString stringWithUTF8String:downloadFilechar_f];
                
//                NSLog(@"downloadFilepropertyName : %@", downloadFilepropertyName);
                
                if([DownloadPathProperty isEqualToString:downloadFilepropertyName]){
                    id downloadFilepropertyValue = [propertyValue valueForKey:(NSString *)downloadFilepropertyName];
                    if(downloadFilepropertyValue){
                        resultFileName = [downloadFilepropertyValue lastPathComponent];
                        //应在此处存储缓存文件名
                        //......
//                        NSLog(@"broken down temp cache path : %@", resultFileName);
                    }
                    break;
                }
            }
            free(downloadFileproperties);
        }else {
            continue;
        }
    }
    free(properties);
    return resultFileName;
}

@end
