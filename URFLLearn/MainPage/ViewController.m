//
//  ViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/2.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "UREFLViewController.h"
#import "URMainLessionTableViewCell.h"
#import "URMainType.h"
#import "NSObject+modelHeight.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, AutoLayoutTableViewCellDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSArray           *itemArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadData];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[URMainLessionTableViewCell class] forCellReuseIdentifier:@"URMainLessionTableViewCellIndentifier"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)loadData
{
    URMainSuggestionItem *item = [[URMainSuggestionItem alloc] init];
    item.name =  @"对话";
    item.logoUrl = @"http://image.iltaw.com/20130311/48/72/290_ULlnQ7iblfK2tX0H.jpg";
    item.modelHeight = 0;
    
    URMainSuggestionItem *item1 = [[URMainSuggestionItem alloc] init];
    item1.name =  @"单词";
    item1.logoUrl = @"http://pic.pc6.com/up/2016-9/2016961950342293102.jpg";
    item1.modelHeight = 0;

    self.itemArray = @[item, item1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    URMainLessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"URMainLessionTableViewCellIndentifier"];
    cell.cellDelegate = self;
    if (!cell) {
        cell = [[URMainLessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"URMainLessionTableViewCellIndentifier"];
    }
    if (indexPath.row < self.itemArray.count) {
        cell.item = [self.itemArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UREFLViewController *controller = [[UREFLViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    URMainSuggestionItem *item = [self.itemArray objectAtIndex:indexPath.row];
    if (item.modelHeight == 0) {
        URMainLessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"URMainLessionTableViewCellIndentifier"];
        CGSize cellSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return cellSize.height;
    }
    
    return item.modelHeight;
}

#pragma mark -

- (void)needUpdateConstraintCell
{
    [self.tableView beginUpdates];
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView endUpdates];
}

@end
