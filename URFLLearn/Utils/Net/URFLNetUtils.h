//
//  URFLNetUtils.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^getJsonCallback)(id);
typedef void (^webDownloadCallback)(NSString *);

@interface URFLNetUtils : NSObject

+ (void)getJson:(NSString *)url parameters:(NSDictionary *)parameters callback:(getJsonCallback)callback;

+ (void)download:(NSString *)url path:(NSString *)path callback:(webDownloadCallback)callback;

@end
