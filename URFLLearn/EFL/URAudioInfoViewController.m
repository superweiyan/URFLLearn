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

@interface URAudioInfoViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) URAudioInfoView   *infoView;
@property (nonatomic, strong) UITableView       *infoTextView;
//@property (nonatomic, strong) NSArray           *dailogueItemArray;
@property (nonatomic, strong) UIView            *noteViews;
@property (nonatomic, strong) EFLAudioModel     *audioModel;

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

#pragma mark - init

- (void)initData
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"audioContext.txt" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:audioPath options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [str convertJson];
    self.audioModel = [self getDialogue:dict];
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
    
    self.noteViews = [self createNoteView];
    [self.view insertSubview:self.noteViews belowSubview:self.infoView];
    
    [self.noteViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-containSpace);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
    }];

    self.infoTextView = [[UITableView alloc] init];
    self.infoTextView.delegate = self;
    self.infoTextView.dataSource = self;
    self.infoTextView.estimatedRowHeight = 80;
    self.infoTextView.backgroundColor = [UIColor whiteColor];
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
}

#pragma mark

- (UIView *)createNoteView
{
    UIView *noteView = [[UIView alloc] init];
    noteView.clipsToBounds = YES;
    noteView.backgroundColor = [UIColor redColor];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(onSwitchViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"收起" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noteView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteView).mas_offset(viewTop);
        make.trailing.mas_equalTo(noteView).mas_offset(-viewLeading);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"关键词组";
    label.font = [UIFont systemFontOfSize:12];
    [noteView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(noteView).mas_offset(viewLeading);
        make.top.mas_equalTo(noteView).mas_offset(viewTop);
        make.height.mas_equalTo(20);
        make.trailing.mas_equalTo(closeBtn.mas_leading).mas_offset(-viewSpace);
    }];
    
    [label setMas_key:@"keyword"];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    [noteView addSubview:textView];
    
    [textView setMas_key:@"text"];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(noteView).mas_offset(viewLeading);
        make.top.mas_equalTo(label.mas_bottom).mas_offset(viewTop);
        make.trailing.mas_equalTo(noteView).mas_offset(-viewLeading);
        make.height.mas_equalTo(65);
//        make.bottom.mas_equalTo(noteView);
    }];
    
    return noteView;
}

- (void)onSwitchViewClicked:(id)sender
{
    CGFloat height = 0;
    if(self.noteViews.frame.size.height == 30) {
        height = 70;
    }
    else {
        height = -70;
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
    
    [UIView animateWithDuration:1 animations:^{
        self.infoTextView.frame = CGRectMake(textViewRect.origin.x, textViewRect.origin.y, textViewRect.size.width, textViewHeight);
        self.noteViews.frame = CGRectMake(rect.origin.x, rect.origin.y - height, rect.size.width, noteHeight);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.noteViews mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(noteHeight);
        }];
        
//        [self.infoTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(textViewHeight);
//        }];
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
    model.exampleSentences = [notes objectForKey:@"example"];
    
    return model;
}

@end
