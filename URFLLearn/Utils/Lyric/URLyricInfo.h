//
//  URLyricInfo.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/12.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLyricData : NSObject

@property (nonatomic, assign) NSUInteger  startOffsetTm;  //开始偏移多少秒
@property (nonatomic, strong) NSString  *lyric;
@end

@interface URLyricInfo : NSObject

//艺人名; 对应 ar
@property (nonatomic, strong) NSString  *artist;

//曲名：对应 ti
@property (nonatomic, strong) NSString  *title;

//专辑：对应al
@property (nonatomic, strong) NSString  *album;

//本歌词编辑者
@property (nonatomic, strong) NSString  *byEdit;

//时间和歌词对应
@property (nonatomic, strong) NSArray<URLyricData *>  *itemArray;

@end
