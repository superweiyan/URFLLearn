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


@implementation URFLNetUtils

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
