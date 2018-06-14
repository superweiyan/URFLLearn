//
//  URFLNetUtils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URFLNetUtils.h"
#import "AFNetworking.h"
#import <objc/runtime.h>

//NSString * const DownloadFileProperty = @"downloadFile";
//NSString * const DownloadPathProperty = @"path";

@implementation URFLNetUtils

//+ (NSString *)tempCacheFileNameForTask:(NSURLSessionDownloadTask *)downloadTask
//{
//    NSString *resultFileName = nil;
//    //拉取属性
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([downloadTask class], &outCount);
//    for (i = 0; i<outCount; i++) {
//        objc_property_t property = properties[i];
//        const char* char_f = property_getName(property);
//        NSString *propertyName = [NSString stringWithUTF8String:char_f];
//
//        NSLog(@"proertyName : %@", propertyName);
//
//        if ([DownloadFileProperty isEqualToString:propertyName]) {
//            id propertyValue = [downloadTask valueForKey:(NSString *)propertyName];
//            unsigned int downloadFileoutCount, downloadFileIndex;
//            objc_property_t *downloadFileproperties = class_copyPropertyList([propertyValue class], &downloadFileoutCount);
//            for (downloadFileIndex = 0; downloadFileIndex < downloadFileoutCount; downloadFileIndex++) {
//                objc_property_t downloadFileproperty = downloadFileproperties[downloadFileIndex];
//                const char* downloadFilechar_f = property_getName(downloadFileproperty);
//                NSString *downloadFilepropertyName = [NSString stringWithUTF8String:downloadFilechar_f];
//
//                NSLog(@"downloadFilepropertyName : %@", downloadFilepropertyName);
//
//                if([DownloadPathProperty isEqualToString:downloadFilepropertyName]){
//                    id downloadFilepropertyValue = [propertyValue valueForKey:(NSString *)downloadFilepropertyName];
//                    if(downloadFilepropertyValue){
//                        resultFileName = [downloadFilepropertyValue lastPathComponent];
//                        //应在此处存储缓存文件名
//                        //......
//                        NSLog(@"broken down temp cache path : %@", resultFileName);
//                    }
//                    break;
//                }
//            }
//            free(downloadFileproperties);
//        }else {
//            continue;
//        }
//    }
//    free(properties);
//
//    return resultFileName;
//}

+ (void)getJson:(NSString *)url parameters:(NSDictionary *)parameters callback:(getJsonCallback)callback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if(callback) {
                callback(responseObject);
            }
             
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
        }];
}

+ (void)download:(NSString *)url path:(NSString *)path callback:(webDownloadCallback)callback
{
    AFURLSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *downloadUrl = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadUrl];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
//        下载进度
        CGFloat progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"%f",1.0 * progress);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *downloadPath = [path stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:downloadPath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (callback) {
            callback(filePath.relativePath);
        }
    }];
    
    [downloadTask resume];
}

@end
