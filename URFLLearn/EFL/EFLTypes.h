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


@interface EFLAudioModel : NSObject

@property (nonatomic, strong) NSArray       *contentItemArray;
@property (nonatomic, strong) NSString      *keyWord;
@property (nonatomic, strong) NSString      *chineseWord;
@property (nonatomic, strong) NSArray       *exampleSentences;

//@property (nonatomic, assign) float     height;

@end
