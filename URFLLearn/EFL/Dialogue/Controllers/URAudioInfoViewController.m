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
#import "URLayoutConfig.h"
#import "URCommonMarco.h"
#import "URAudioNoteView.h"
#import "URPathConfig.h"

@interface URAudioInfoViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) URAudioInfoView   *infoView;
@property (nonatomic, strong) UITableView       *infoTextView;
@property (nonatomic, strong) URAudioNoteView   *noteViews;
@property (nonatomic, strong) EFLAudioModel     *audioModel;
@property (nonatomic, strong) UIButton          *prevBtn;
@property (nonatomic, strong) UIButton          *nextBtn;
@property (nonatomic, assign) NSInteger         currentIndex;

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
    return self.audioModel.contentItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.audioModel.contentItemArray.count) {
        
        if (indexPath.row % 2 == 0) {
            UREFLAudioDialogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioDialogueIndentifer"];
            cell.audioContent = [self.audioModel.contentItemArray objectAtIndex:indexPath.row];
            return cell;
        }
        else {
            UREFLAudioDialoguePeerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioDialoguePeerIndentifer"];
            cell.audioContent = [self.audioModel.contentItemArray objectAtIndex:indexPath.row];;
            return cell;
        }
    }
    return [UITableViewCell new];
}

#pragma mark - action

- (void)onNextBtnClicked:(id)sender
{
    if(self.currentIndex == self.audioModelArray.count - 1) {
        return ;
    }
    self.currentIndex += 1;
    NSString *key = [self.audioModelArray objectAtIndex:self.currentIndex];
    [self switchAudioModel:key];
}

- (void)onPrevBtnClicked:(id)sender
{
    if(self.currentIndex == 0) {
        return ;
    }
    self.currentIndex -= 1;
    NSString *key = [self.audioModelArray objectAtIndex:self.currentIndex];
    [self switchAudioModel:key];
}

#pragma mark - init

- (void)initData
{
    self.currentIndex = 0;
    NSString *key = [self.audioModelArray objectAtIndex:self.currentIndex];
    [self switchAudioModel:key];
}

- (void)switchAudioModel:(NSString *)key
{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.txt", [URPathConfig getEFLAudioLession], self.lessionId, key];
    NSString *audioPath = [NSString stringWithFormat:@"%@/%@/%@.MP3", [URPathConfig getEFLAudioLession], self.lessionId, key];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *dict = [content convertJson];
    self.audioModel = [self getDialogue:dict];
    
    self.noteViews.audioModel = self.audioModel;
    [self.infoView playAudio:audioPath];
    [self.infoTextView reloadData];
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
    
    [self createNoteView];

    self.infoTextView = [[UITableView alloc] init];
    self.infoTextView.delegate = self;
    self.infoTextView.dataSource = self;
    self.infoTextView.estimatedRowHeight = 80;
    self.infoTextView.backgroundColor = [UIColor colorWithString:URBackgroudColor];
    self.infoTextView.rowHeight = UITableViewAutomaticDimension;
    self.infoTextView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.infoTextView];
    [self.infoTextView registerClass:[UREFLAudioDialogueTableViewCell class] forCellReuseIdentifier:@"AudioDialogueIndentifer"];
    [self.infoTextView registerClass:[UREFLAudioDialoguePeerTableViewCell class] forCellReuseIdentifier:@"AudioDialoguePeerIndentifer"];
    
    [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height + 20 + 10);
        make.leading.trailing.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view).mas_offset(-containSpace * 3 - 30 - 40);
        make.bottom.mas_equalTo(self.noteViews.mas_top).mas_offset(-viewSpace);
    }];
    
    self.prevBtn = [[UIButton alloc] init];
    self.prevBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.prevBtn.layer.borderWidth = 1;
    self.prevBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.prevBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.prevBtn setTitle:@"上一篇" forState:UIControlStateNormal];
    [self.prevBtn addTarget:self action:@selector(onPrevBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.prevBtn];
    
    [self.prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).mas_offset(containSpace);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.bottom.mas_equalTo(self.noteViews.mas_top).mas_offset(-10);
    }];
    
    self.nextBtn = [[UIButton alloc] init];
    self.nextBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.nextBtn.layer.borderWidth = 1;
    [self.nextBtn setTitle:@"下一篇" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn addTarget:self action:@selector(onNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.view).mas_offset(-containSpace);
        make.size.mas_equalTo(CGSizeMake(50, 30));
//        make.centerY.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.noteViews.mas_top).mas_offset(-10);
    }];
}

#pragma mark - note

- (void)createNoteView
{
    self.noteViews = [[URAudioNoteView alloc] init];
    WeakSelf
    self.noteViews.audioNoteCallbaak = ^{
        [weakSelf onSwitchViewClicked];
    };
    
    [self.view insertSubview:self.noteViews belowSubview:self.infoView];
    
    [self.noteViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-containSpace);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
}

- (void)onSwitchViewClicked
{
    CGFloat height = 0;
    if(self.noteViews.frame.size.height == 30) {
        height = self.noteViews.expectHeight;
    }
    else {
        height = -self.noteViews.expectHeight;
    }
    
//    case 0
    
//    [self.noteViews mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
//
//    [self.infoTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-containSpace * 2 - height - 40);
//    }];
    
//    [self.view setNeedsUpdateConstraints]; //通知系统视图中的约束需要更新
//    [self.view updateConstraintsIfNeeded]; //

//    [UIView animateWithDuration:2 animations:^{
//        [self.infoTextView layoutIfNeeded];
//        [self.noteViews layoutIfNeeded];
//    }];
    
//    case 1
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CGRect rect = self.noteViews.frame;
    CGRect textViewRect = self.infoTextView.frame;
    
    CGFloat noteHeight = rect.size.height + height;
    CGFloat textViewHeight = textViewRect.size.height - height;
    
    WeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.infoTextView.frame = CGRectMake(textViewRect.origin.x,
                                                 textViewRect.origin.y,
                                                 textViewRect.size.width,
                                                 textViewHeight);
        
        weakSelf.noteViews.frame = CGRectMake(rect.origin.x,
                                              rect.origin.y - height,
                                              rect.size.width,
                                              noteHeight);
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf.noteViews mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(noteHeight);
        }];
    }];
}

#pragma mark - parser

- (EFLAudioModel *)getDialogue:(NSDictionary *)dict
{
    EFLAudioModel *model = [[EFLAudioModel alloc] init];
    NSDictionary *notes = [dict objectForKey:@"notes"];
    
    model.contentItemArray = [dict objectForKey:@"dialogue"];
    model.keyWord = [notes objectForKey:@"word"];
    model.chineseWord = [notes objectForKey:@"chinese"];
    
    NSArray *sentences = [notes objectForKey:@"example"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < sentences.count; i++) {
        NSDictionary *dict = [sentences objectAtIndex:i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            EFLAudioExampleModel *example = [[EFLAudioExampleModel alloc] init];
            example.englist = [dict objectForKey:@"key"];
            example.chinese = [dict objectForKey:@"value"];

            [array addObject:example];
        }
    }
    model.exampleSentences = array;
    return model;
}

@end
