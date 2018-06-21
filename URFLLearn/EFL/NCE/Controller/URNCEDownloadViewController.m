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
#import "URDownloadFileUtils.h"
#import "URModuleManager.h"
#import "URNCEModule.h"
#import "URNCEInfoViewController.h"

#import <objc/runtime.h>

@interface URNCEDownloadViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    cell.tipName = [NSString stringWithFormat:@"新概念英语%ld",  indexPath.row];
    if (indexPath.row < self.volumeInfo.count) {
        NSString *url = [self.volumeInfo objectAtIndex:indexPath.row];
        cell.url = url;
        cell.hadDownload = [[URModuleManager sharedObject].nceModule hadDownloadCache:url];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = [self.volumeInfo objectAtIndex:indexPath.row];
    NSString *filePath = [[URModuleManager sharedObject].nceModule hadDownloadedFile:url];
    if(filePath.length > 0) {
        URNCEInfoViewController *controller = [[URNCEInfoViewController alloc] init];
        controller.volumePath = filePath;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [[URModuleManager sharedObject].nceModule downloadFileForUrl:url];
    }
}

@end
