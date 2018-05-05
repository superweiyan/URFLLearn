//
//  URFLNetUtils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URFLNetUtils.h"
#import "AFNetworking.h"

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
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *downloadUrl = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadUrl];
    
    [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        //下载进度         CGFloat progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//        NSLog(@"%f",1.0 * progress);
        
        //一定要使用"setProgressWithDownloadProgressOfTask"方法设置进度,不然进度条无法刷新
//        [progressView setProgressWithDownloadProgressOfTask:_downloadTask animated:true];
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //设置缓存路径         NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *downloadPath = [path stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:downloadPath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        下载完成后打印路径
        NSLog(@"%@",filePath);
    }];

}

@end
