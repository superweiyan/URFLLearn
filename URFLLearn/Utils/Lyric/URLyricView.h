//
//  URLyricView.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/10.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class URLyricInfo;

@interface URLyricView : UIView

@property (nonatomic, strong) URLyricInfo *lyricInfo;

@property (nonatomic, assign) NSInteger  currentPlayTm;

@end
