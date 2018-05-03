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

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL      isOther;
@property (nonatomic, assign) float     height;

@end
