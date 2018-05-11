//
//  URCommonMarco.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/4.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WeakSelf __weak __typeof(self) weakSelf = self;


#define jumpViewController(name)    id cls = [[NSClassFromString(name) alloc] init]; \
                                    if ([cls isKindOfClass:[UIViewController class]]) { \
                                        [self.navigationController pushViewController:cls animated:YES]; \
                                    } \
                                    else { \
NSLog(@"jumpViewController fail"); \
                                    }

