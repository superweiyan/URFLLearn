//
//  EFLModule.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "EFLModule.h"
#import "URPathConfig.h"
#import "URFLNetUtils.h"
#import "SSZipArchive.h"

@implementation EFLModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (![self checkAudioLession:@"EFL01"]) {
            [self downloadAudioLession];
        }
    }
    return self;
}

#pragma mark - init

- (void)downloadAudioLession
{
    [URFLNetUtils download:@"http://makefriends.bs2dl.yy.com/EFL01.zip"
                      path:[URPathConfig getcheckDownloadCachePath]
                  callback:^(NSString *filePath) {
        
                      if (filePath.length) {
                          [self unzipAudioLession:filePath callback:^(BOOL success, NSError *error) {
                              if(success) {
                                  NSLog(@"download and unzip success");
                              }
                              else {
                                  NSLog(@"downloadAudioLession unzip error:%@", error.localizedDescription);
                              }
                          }];
                      }
    }];
}

- (BOOL)checkAudioLession:(NSString *)lessionName
{
    NSString *lessionPath = [URPathConfig getEFLAudioLession];
    lessionPath = [lessionPath stringByAppendingPathComponent:lessionName];
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:lessionPath isDirectory:&isDir]) {
        return YES;
    }
    return NO;
}

- (void)unzipAudioLession:(NSString *)filePath callback:(unzipCallback)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [SSZipArchive unzipFileAtPath:filePath toDestination:[URPathConfig getEFLAudioLession]
                      progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callback) {
                    callback(succeeded, error);
                }
            });
        }];
    });
}



@end
