//
//  URLyricModule.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/10.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URLyricModule.h"
#import "URFileUtils.h"
#import "URLyricInfo.h"

@implementation URLyricModule

+ (URLyricInfo *)loadLyricInfo:(NSString *)lyricInfo
{
    URLyricInfo *lyric = [[URLyricInfo alloc] init];
    
    NSArray *orignLyricArray = [lyricInfo componentsSeparatedByString:@"\n"];
    
    NSMutableArray *lyricArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < orignLyricArray.count; i++) {
        NSString *lyricLine = [orignLyricArray objectAtIndex:i];
        BOOL isLyric = [self isLyricPart:[lyricLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                    info:&lyric];
        if(!isLyric) {
            NSArray *data = [self parseLyricData:lyricLine];
            if (data) {
                [lyricArray addObjectsFromArray:data];
            }
        }
    }
    
    lyric.itemArray = lyricArray;
    return lyric;
}

+ (URLyricInfo *)loadLyricPath:(NSString *)path
{
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSString *lyricInfo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [URLyricModule loadLyricInfo:lyricInfo];
}

+ (BOOL)isLyricPart:(NSString *)lyricString info:(URLyricInfo **)info
{
    if ([lyricString hasPrefix:@"[ti"]) {
        (*info).title = [lyricString substringWithRange:NSMakeRange(4, lyricString.length - 5)];
        return YES;
    }
    else if ([lyricString hasPrefix:@"[ar"]) {
        (*info).artist = [lyricString substringWithRange:NSMakeRange(4, lyricString.length - 5)];
        return YES;
    }
    else if ([lyricString hasPrefix:@"[by"]) {
        (*info).byEdit = [lyricString substringWithRange:NSMakeRange(4, lyricString.length - 5)];
        return YES;
    }
    else if ([lyricString hasPrefix:@"[al"]) {
        (*info).album = [lyricString substringWithRange:NSMakeRange(4, lyricString.length - 5)];
        return YES;
    }
    return NO;
}

+ (NSArray *)parseLyricData:(NSString *)lyricString
{
    if (lyricString.length == 0) {
        return nil;
    }
    
    NSArray *timeArray = [lyricString componentsSeparatedByString:@"]"];
    NSString *lyric = [timeArray lastObject];
    
    NSMutableArray  *itemArray = [[NSMutableArray alloc] init];
    
    if (timeArray.count > 2) {
        for (int i = 0; i < timeArray.count - 1; i++) {
            NSString *tmString = [timeArray objectAtIndex:i];
            NSString *tm = [tmString substringFromIndex:1];
            
            NSUInteger playTime = [self parsePlayTime:tm];
            if(playTime > 0) {
                URLyricData *data = [[URLyricData alloc] init];
                data.lyric = lyric;
                data.startOffsetTm = playTime;
                [itemArray addObject:data];
            }
        }
    }
    else {
        NSString *tmString = timeArray.firstObject;
        NSString *tm = [tmString substringFromIndex:1];
        
        NSUInteger playTime = [self parsePlayTime:tm];
        if(playTime > 0) {
            URLyricData *data = [[URLyricData alloc] init];
            data.lyric = lyric;
            data.startOffsetTm = playTime;
            [itemArray addObject:data];
        }
        
        
    }
    return itemArray;
}

+ (NSUInteger)parsePlayTime:(NSString *)tm
{
    NSString *minute = [tm substringToIndex:2];
    NSString *sec = [tm substringWithRange:NSMakeRange(3, 2)];
    
    return minute.integerValue * 60 + sec.integerValue;
//    [tm substringWithRange:NSMakeRange(6, 2)];
}

@end
