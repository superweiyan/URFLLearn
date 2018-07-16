//
//  URLyricView.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/7/10.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URLyricView.h"
#import "URLyricInfo.h"

@interface URLyricView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView           *infoTableView;
@property (nonatomic, strong) NSMutableArray        *lyricArray;
@property (nonatomic, strong) NSMutableArray        *startTimeOffset;
@property (nonatomic, assign) NSUInteger            currentPlayLyric;

@end

@implementation URLyricView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.startTimeOffset = [[NSMutableArray alloc] init];
        
        self.infoTableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.infoTableView.delegate = self;
        self.infoTableView.dataSource = self;
        self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"URLyricInfoIndentifier"];
        [self addSubview:self.infoTableView];
    }
    return self;
}

- (void)setLyricInfo:(URLyricInfo *)lyricInfo
{
    _lyricInfo = lyricInfo;
    
    if (self.lyricArray.count > 0) {
        [self.lyricArray removeAllObjects];
    }
    if (!self.lyricArray) {
        self.lyricArray = [[NSMutableArray alloc] init];
    }
        
    NSArray *sortArray = [lyricInfo.itemArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return ((URLyricData *)obj1).startOffsetTm > ((URLyricData *)obj2).startOffsetTm;
    }];
    
    for (int i = 0; i < sortArray.count ; i++) {
        URLyricData *obj = [sortArray objectAtIndex:i];
        if (obj.startOffsetTm > 0 && self.currentPlayLyric == 0) {
            self.currentPlayLyric = self.lyricArray.count;
        }
        
        [self.lyricArray addObject:obj.lyric];
        [self.startTimeOffset addObject:@(obj.startOffsetTm)];
    }
    
    [self.infoTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == (self.lyricArray.count + 1)) {
        return [[UITableViewCell alloc] init];
    }
    else if (indexPath.row < (self.lyricArray.count + 1)) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"URLyricInfoIndentifier"];
        cell.textLabel.text = [self.lyricArray objectAtIndex:(indexPath.row - 1)];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == (self.lyricArray.count+1)) {
        return self.bounds.size.height/2;
    }
    return 40.0;
}

- (void)setCurrentPlayTm:(NSInteger)currentPlayTm
{
    for (int i = 0; i < self.startTimeOffset.count; i++) {
        NSNumber *tm = [self.startTimeOffset objectAtIndex:i];
        if (tm.integerValue == currentPlayTm) {
            [self.infoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(i+1) inSection:0]
                                      atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
    }
}


//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor blueColor];
//    return headerView;
//}
//// custom view for header. will be adjusted to default or specified header height
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] init];
//    footerView.backgroundColor = [UIColor redColor];
//    return footerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat height = 100; //self.infoTableView.frame.size.height/2;
//    return height;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    CGFloat height = 100; //self.infoTableView.frame.size.height/2;
//    return height;
//}

@end
