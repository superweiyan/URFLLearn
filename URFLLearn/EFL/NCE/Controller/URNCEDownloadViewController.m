//
//  URNCEDownloadViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/10.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEDownloadViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "URNCEDownloadTableViewCell.h"

@interface URNCEDownloadViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) UITableView  *downloadList;

@end

@implementation URNCEDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.downloadList = [[UITableView alloc] init];
    self.downloadList.dataSource = self;
    self.downloadList.delegate = self;
    [self.view addSubview:self.downloadList];
    [self.downloadList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.downloadList registerClass:[URNCEDownloadTableViewCell class] forCellReuseIdentifier:@"downloadIndentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.volumeInfo.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    URNCEDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadIndentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"新概念英语%ld",  indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self downloadPackage:indexPath.row];
}

- (void)downloadPackage:(NSUInteger)index
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://makefriends.bs2dl.yy.com/NCE1_1.zip"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
//    NSCachedURLResponse *response = [configuration.URLCache cachedResponseForRequest:req];
    
//    [req setvalue:range for]
    
//    manager downloadTaskWithResumeData:<#(nonnull NSData *)#> progress:<#^(NSProgress * _Nonnull downloadProgress)downloadProgressBlock#> destination:<#^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)destination#> completionHandler:<#^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)completionHandler#>
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:^(NSProgress *downloadProgress){
        
        NSLog(@"++++++++++++++++++++ %f", 100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];

            NSURL *newUrl = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            NSLog(@"newUrl %@", newUrl.absoluteString);
            return newUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"file path %@", filePath);
    }];
    
    [downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

//- (void)loadVolumeDict
//{
//    self.volumeDict = @{ @"1" : @[@"http://makefriends.bs2dl.yy.com/NCE1_1.zip",
//                                  @"http://makefriends.bs2dl.yy.com/NCE1_2.zip",
//                                  @"http://makefriends.bs2dl.yy.com/NCE1_3.zip",
//                                  @"http://makefriends.bs2dl.yy.com/NCE1_4.zip"] };
//}


@end
