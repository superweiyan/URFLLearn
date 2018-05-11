//
//  EFLTypes.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFLTypes : NSObject

@end

@interface EFLAudioExampleModel : NSObject

@property (nonatomic, strong) NSString *englist;    //英文例子
@property (nonatomic, strong) NSString *chinese;    //中文翻译

@end

@interface EFLAudioModel : NSObject

@property (nonatomic, strong) NSArray       *contentItemArray;
@property (nonatomic, strong) NSString      *keyWord;
@property (nonatomic, strong) NSString      *chineseWord;
@property (nonatomic, strong) NSArray       *exampleSentences;

@end

@interface EFLLessionInfoModel : NSObject

@property (nonatomic, strong) NSString * lessionId;
@property (nonatomic, strong) NSString * lessionName;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * note;

@end
