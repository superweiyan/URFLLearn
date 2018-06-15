//
//  URNCEModule.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/15.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URNCEModule : NSObject

- (void)downloadFileForUrl:(NSString *)url dest:(NSString *)dest completeHandler:(void (^)(void))completeHandler;

- (void)downloadFileForUrl:(NSString *)url;

@end
