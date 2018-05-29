//
//  EFLLessonUtils.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/29.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "EFLLessonUtils.h"
#import "URPathConfig.h"
#import "NSString+Utils.h"
#import "NSDictionary+Utils.h"
#import "EFLTypes.h"

@implementation EFLLessonUtils

+ (NSArray *)parserLessonJson
{
    NSString *path = [URPathConfig loadNSBundleResurce:@"EFL.json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [jsonString convertJson];
    
    NSArray *datas = [dict URGetArray:@"datas"];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < datas.count; i++) {
        [itemsArray addObject:[EFLLessonUtils parseItem:datas[i]]];
    }
    
    return itemsArray;
}

+ (EFLLessonInfoModel *)parseItem:(NSDictionary *)info
{
    EFLLessonInfoModel *infoModel = [[EFLLessonInfoModel alloc] init];
    infoModel.lessonId = [info URGetString:@"lessonId"];
    infoModel.lessonName = [info URGetString:@"name"];
    infoModel.note = [info URGetString:@"description"];
    infoModel.logo = [info URGetString:@"logo"];
    
    return infoModel;
}


@end
