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

@end
