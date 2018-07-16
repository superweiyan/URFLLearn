//
//  URNCEInfoViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/9.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEInfoViewController.h"
#import "URNCEModule.h"
#import "URModuleManager.h"
#import "Masonry.h"

@interface URNCEInfoViewController ()

@property (nonatomic, strong) UITableView           *contentView;
@property (nonatomic, strong) UIProgressView        *progressView;
@property (nonatomic, strong) UIProgressView        *audioProgressView;
@property (nonatomic, strong) UIButton              *repeatBtn;
@property (nonatomic, strong) UIButton              *prevBtn;
@property (nonatomic, strong) UIButton              *nextBtn;
@property (nonatomic, strong) UIButton              *playBtn;
@property (nonatomic, strong) UIButton              *playListBtn;

@end

@implementation URNCEInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
    [self loadData];
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

- (void)initViews
{
    self.audioProgressView = [[UIProgressView alloc] init];
    [self.view addSubview:self.audioProgressView];
    [self.audioProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(5);
        make.leading.mas_equalTo(self.view).mas_offset(5);
        make.trailing.mas_equalTo(self.view).mas_offset(-5);
        make.height.mas_offset(20);
    }];
    
    self.repeatBtn = [[UIButton alloc] init];
    [self.view addSubview:self.repeatBtn];
    self.repeatBtn.backgroundColor = [UIColor redColor];
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-15);
        make.leading.mas_equalTo(self.view).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    self.playBtn = [[UIButton alloc] init];
    [self.view addSubview:self.playBtn];
    self.playBtn.backgroundColor = [UIColor redColor];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.bottom.mas_equalTo(self.view).mas_offset(-15);
    }];
    
    self.prevBtn = [[UIButton alloc] init];
    self.prevBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.prevBtn];
    [self.prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.trailing.mas_equalTo(self.playBtn.mas_leading).mas_offset(-20);
    }];

    self.nextBtn = [[UIButton alloc] init];
    self.nextBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.leading.mas_equalTo(self.playBtn.mas_trailing).mas_offset(20);
    }];
    
    self.playListBtn = [[UIButton alloc] init];
    self.playListBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.playListBtn];
    [self.playListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.trailing.mas_equalTo(self.view).mas_offset(-20);
    }];

    self.progressView = [[UIProgressView alloc] init];
    [self.view addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).mas_offset(10);
        make.trailing.mas_equalTo(self.view).mas_offset(-10);
        make.bottom.mas_equalTo(self.playBtn.mas_top).mas_offset(-10);
        make.height.mas_equalTo(15);
    }];
}

- (void)loadData
{
    NSString *jsonPath = [self.volumePath stringByAppendingPathComponent:@"content.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError* error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    NSLog(@"%@", json);
}

@end
