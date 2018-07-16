//
//  URTestViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/11.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URTestViewController.h"
#import "URLyricTestViewController.h"

@interface URTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *testConfigTable;
@property (nonatomic, strong) NSArray       *itemArray;

@end

@implementation URTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.itemArray = @[@"歌词测试"];
    
    self.testConfigTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.testConfigTable.dataSource = self;
    self.testConfigTable.delegate = self;
    [self.view addSubview:self.testConfigTable];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tabBarController.view.frame = self.view.bounds;
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
    return self.itemArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testConfig"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testConfig"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.itemArray.count) {
        NSString *txt = [self.itemArray objectAtIndex:indexPath.row];
        cell.textLabel.text = txt;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        URLyricTestViewController *controller = [[URLyricTestViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
