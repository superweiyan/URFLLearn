//
//  URLyricModule.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/10.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class URLyricInfo;

@interface URLyricModule : NSObject

//- (void)parseLyricBlock:(NSString *)block callback:^(NSArray *)lyricInfo;

+ (URLyricInfo *)loadLyricInfo:(NSString *)lyricInfo;

+ (URLyricInfo *)loadLyricPath:(NSString *)path;

@end
