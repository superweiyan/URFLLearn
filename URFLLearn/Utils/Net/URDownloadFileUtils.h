//
//  URDownloadFileUtils.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/13.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>


@interface URDownloadFileUtils : NSObject

+ (instancetype)sharedObject;

- (void)downloadFile:(NSString *)url
                dest:(NSString *)dest
            progress:(void(^)(CGFloat progress))progress
   completionHandler:(void(^)(void))completionHandler;

- (void)removeTmpFile:(NSString *)url;

@end
