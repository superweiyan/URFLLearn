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

@implementation URNCEModule

- (void)downloadFileForUrl:(NSString *)url dest:(NSString *)dest completeHandler:(void (^)(void))completeHandler
{
    [[URDownloadFileUtils sharedObject] downloadFile:url dest:nil progress:^(CGFloat progress) {
        
    } completionHandler:^(NSString *filePath){
        
    }];
}

- (void)downloadFileForUrl:(NSString *)url
{
    [[URDownloadFileUtils sharedObject] downloadFile:url dest:nil progress:^(CGFloat progress) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{@"url":url, @"progress":@(progress)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadProgressNotification object:nil userInfo:userInfo];
        });
        
    } completionHandler:^(NSString *filePath) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadFileFinishNotification object:nil];
    }];

}

@end
