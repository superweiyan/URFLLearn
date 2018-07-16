//
//  URLyricTestViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/12.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URLyricTestViewController.h"
#import "URLyricView.h"
#import "URLyricModule.h"
#import "URPathConfig.h"
#import "URLyricInfo.h"

@interface URLyricTestViewController ()

@property (nonatomic, strong) URLyricView   *lyricView;
@property (nonatomic, strong) NSArray       *lyricItemArray;
@property (nonatomic, strong) URLyricInfo   *lyricData;

@end

@implementation URLyricTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    self.lyricView = [[URLyricView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    self.lyricView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lyricView];
    self.lyricView.lyricInfo = self.lyricData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadData
{
    NSString *info = [URPathConfig loadNSBundleResurce:@"01－A Private Conversation.lrc"];
    self.lyricData = [URLyricModule loadLyricPath:info];
}

@end
