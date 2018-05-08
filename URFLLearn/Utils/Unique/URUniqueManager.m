//
//  URUniqueManager.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/7.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URUniqueManager.h"
#import "URkeyChain.h"

//static NSArray *numberArray = @[@"1", @"2", @"3"]

#define KeyChainUniqueKey @"com.unreal.URFLLearn.uniqueKey"

@interface URUniqueManager()


@property (nonatomic, strong) NSArray *randNumberArray;

@end

@implementation URUniqueManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.randNumberArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                                 @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",
                                 @"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",
                                 @"s",@"t",@"u",@"v",@"w",@"s",@"y",@"z",@"A",
                                 @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
                                 @"K", @"L", @"M", @"N", @"U", @"V", @"W", @"X", @"Y",
                                 @"Z"];
        
        NSString *uniqueKey = [URkeyChain load:KeyChainUniqueKey];
        if (uniqueKey.length == 0) {
            NSString * unique = [self generateUnique];
            [URkeyChain save:KeyChainUniqueKey data:unique];
        }
    }
    return self;
}

- (NSString *)generateUnique
{
    NSMutableString *uniqueString = [[NSMutableString alloc] init];
    for (int i = 0; i < 40; i++) {
        if (i % 10 == 0 && i > 0) {
            [uniqueString appendString:@"-"];
        }
        int index = arc4random() % self.randNumberArray.count;
        [uniqueString appendString:[self.randNumberArray objectAtIndex:index]];
    }
    NSLog(@"+++%@", uniqueString);
    return uniqueString;
}


@end
