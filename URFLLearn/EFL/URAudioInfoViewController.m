//
//  URAudioInfoViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/2.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URAudioInfoViewController.h"
#import "URAudioInfoView.h"
#import "Masonry.h"
#import "URColorConfig.h"
#import "UIColor+Hex.h"
#import "NSString+Utils.h"
#import "UREFLAudioDialogueTableViewCell.h"
#import "EFLTypes.h"
#import "UREFLAudioDialoguePeerTableViewCell.h"

@interface URAudioInfoViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) URAudioInfoView   *infoView;
@property (nonatomic, strong) UITableView       *infoTextView;
@property (nonatomic, strong) NSArray           *dailogueItemArray;

@end

@implementation URAudioInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithString:URBackgroudColor];
    
    [self initViews];
    [self initData];
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    if ([self.infoTextView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.infoTextView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
}

#pragma mark - delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dailogueItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dailogueItemArray.count) {
        
        EFLAudioModel *model = [self.dailogueItemArray objectAtIndex:indexPath.row];
        
        if (model.isOther) {
            UREFLAudioDialogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioDialogueIndentifer"];
            cell.audioModel = model;
            return cell;
        }
        else {
            UREFLAudioDialoguePeerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioDialoguePeerIndentifer"];
            cell.audioModel = model;
            return cell;
        }
    }
    return [UITableViewCell new];
}

#pragma mark - init

- (void)initData
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"audioContext.txt" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:audioPath options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str convertJson];
    
    self.dailogueItemArray = [self getDialogue:dict];
}

- (void)initViews
{
    self.infoView = [[URAudioInfoView alloc] init];
    [self.infoView playAudio:@""];
    [self.view addSubview:self.infoView];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.view).mas_offset(-10);
    }];
    
    self.infoTextView = [[UITableView alloc] init];
    self.infoTextView.delegate = self;
    self.infoTextView.dataSource = self;
    self.infoTextView.estimatedRowHeight = 80;
    self.infoTextView.backgroundColor = [UIColor clearColor];
    self.infoTextView.rowHeight = UITableViewAutomaticDimension;
    self.infoTextView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.infoTextView];
    [self.infoTextView registerClass:[UREFLAudioDialogueTableViewCell class] forCellReuseIdentifier:@"AudioDialogueIndentifer"];
    [self.infoTextView registerClass:[UREFLAudioDialoguePeerTableViewCell class] forCellReuseIdentifier:@"AudioDialoguePeerIndentifer"];
    
    [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height + 20 + 10);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-10);
    }];
}

#pragma mark - parser

- (NSArray *)getDialogue:(NSDictionary *)dict
{
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    NSArray *dialogue = [dict objectForKey:@"dialogue"];
    if ([dialogue isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < dialogue.count; i++) {
            EFLAudioModel *model = [[EFLAudioModel alloc] init];
            model.content = [dialogue objectAtIndex:i];
            model.isOther = i % 2;
            [itemArray addObject:model];
        }
    }
    return itemArray;
}

@end
