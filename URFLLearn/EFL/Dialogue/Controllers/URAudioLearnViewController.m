//
//  URAudioLearnViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/2.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URAudioLearnViewController.h"
#import "Masonry.h"
#import "URAudioInfoViewController.h"

@interface URAudioLearnViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView               *audioTableView;
@property (nonatomic, strong) NSArray<NSString *>       *lessionArray;

@end

@implementation URAudioLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    self.audioTableView = [[UITableView alloc] init];
    self.audioTableView.delegate = self;
    self.audioTableView.dataSource = self;
    [self.view addSubview:self.audioTableView];
    
    [self.audioTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)initData
{
    self.lessionArray = @[@"lession 1"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lessionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndexPathIndentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexPathIndentifier"];
    }
    
    if (indexPath.row < self.lessionArray.count) {
        cell.textLabel.text = [self.lessionArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    URAudioInfoViewController *controller = [[URAudioInfoViewController alloc] init];
    controller.lessionId = @"EFL02";
    controller.audioModelArray = [self getLessionArray:@"EFL02"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray *)getLessionArray:(NSString *)lessionId
{
    return @[@"391", @"392", @"393", @"394", @"395"];
}

@end

