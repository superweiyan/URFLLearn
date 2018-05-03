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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dailogueItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UREFLAudioDialogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioDialogueIndentifer"];
    if (indexPath.row < self.dailogueItemArray.count) {
        
    }
    return cell;
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
    [self.view addSubview:self.infoTextView];
    [self.infoTextView registerClass:[UREFLAudioDialogueTableViewCell class] forCellReuseIdentifier:@"AudioDialogueIndentifer"];
    
    [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height + 20 + 10);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-10);
    }];
}

#pragma mark - parser

- (NSArray *)getDialogue:(NSDictionary *)dict
{
    NSArray *dialogue = [dict objectForKey:@"dialogue"];
    if ([dialogue isKindOfClass:[NSArray class]]) {
        return dialogue;
    }
    return nil;
}

@end
