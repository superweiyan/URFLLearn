//
//  URNCECore.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/10.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCECore.h"
#import "AFNetworking.h"

@interface URNCECore()

@property (nonatomic, strong) NSDictionary *volumeDict;

@end

@implementation URNCECore

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadVolumeDict];
    }
    return self;
}

- (void)downloadFile:(NSUInteger)volumeIndex
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://makefriends.bs2dl.yy.com/NCE1_1.zip"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"file path %@", filePath);
        
    }];
    
    [downloadTask resume];
}

- (void)loadVolumeDict
{
    self.volumeDict = @{ @"1" : @[@"http://makefriends.bs2dl.yy.com/NCE1_1.zip",
                                 @"http://makefriends.bs2dl.yy.com/NCE1_2.zip",
                                 @"http://makefriends.bs2dl.yy.com/NCE1_3.zip",
                                 @"http://makefriends.bs2dl.yy.com/NCE1_4.zip"] };
}

@end
