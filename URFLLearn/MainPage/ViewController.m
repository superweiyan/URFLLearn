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
#import "URNCEViewController.h"
#import "URTestViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, AutoLayoutTableViewCellDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSArray           *itemArray;
@property (nonatomic, strong) NSArray           *JPItemArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configTestViewController];
    
    [self loadData];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[URMainLessionTableViewCell class] forCellReuseIdentifier:@"URMainLessionTableViewCellIndentifier"];
}

- (void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

- (void)loadData
{
    URMainSuggestionItem *item = [[URMainSuggestionItem alloc] init];
    item.name =  @"对话";
    item.logoUrl = @"http://image.iltaw.com/20130311/48/72/290_ULlnQ7iblfK2tX0H.jpg";
    item.modelHeight = 0;
    item.typeId = @"EngCon";
    
    URMainSuggestionItem *item1 = [[URMainSuggestionItem alloc] init];
    item1.name =  @"单词";
    item1.logoUrl = @"http://pic.pc6.com/up/2016-9/2016961950342293102.jpg";
    item1.modelHeight = 0;
    item1.typeId = @"EngWord";
    
    URMainSuggestionItem *item2 = [[URMainSuggestionItem alloc] init];
    item2.name =  @"新概念英语";
    item2.logoUrl = @"http://www.517australia.com/upload/2014/07/201407071451591727.jpg";
    item2.modelHeight = 0;
    item2.typeId = @"EngNCE";


    self.itemArray = @[item, item1, item2];
    
    URMainSuggestionItem *JPItem = [[URMainSuggestionItem alloc] init];
    JPItem.name =  @"50音图";
    JPItem.logoUrl = @"http://pic.pc6.com/up/2017-8/201782220585444264657.jpg";
    JPItem.modelHeight = 0;
    JPItem.typeId = @"JPWord";
    
    URMainSuggestionItem *JPItem1 = [[URMainSuggestionItem alloc] init];
    JPItem1.name =  @"单词";
    JPItem1.logoUrl = @"http://pic.pc6.com/up/2016-12/20161220195164315314.jpg";
    JPItem1.modelHeight = 0;
    JPItem1.typeId = @"JPWord";
    
    self.JPItemArray = @[JPItem, JPItem1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"英语";
    } else if( section == 1) {
        return @"日语";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.itemArray.count;
    }
    else if(section == 1) {
        return self.JPItemArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    URMainLessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"URMainLessionTableViewCellIndentifier"];
    cell.cellDelegate = self;
    
    if (indexPath.section == 0) {
        if (indexPath.row < self.itemArray.count) {
            cell.item = [self.itemArray objectAtIndex:indexPath.row];
        }
    }
    else {
        if (indexPath.row < self.JPItemArray.count) {
            cell.item = [self.JPItemArray objectAtIndex:indexPath.row];
        }
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            URNCEViewController *controller = [[URNCEViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            UREFLViewController *controller = [[UREFLViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else {
        UREFLViewController *controller = [[UREFLViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    URMainSuggestionItem *item = nil;
    
    if (indexPath.section == 0) {
        item = [self.itemArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1){
        item = [self.JPItemArray objectAtIndex:indexPath.row];
    }
    else {
    
    }
    
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

- (void)configTestViewController
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"配置"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(onJoinConfigViewController)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)onJoinConfigViewController
{
    URTestViewController *controller = [[URTestViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
