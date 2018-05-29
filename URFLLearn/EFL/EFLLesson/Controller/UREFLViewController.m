//
//  UREFLViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/9.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "UREFLViewController.h"
#import "URPathConfig.h"
#import "NSString+Utils.h"
#import "Masonry.h"
#import "EFLTypes.h"
#import "URLayoutConfig.h"
#import "URCommonMarco.h"
#import "EFLLessonUtils.h"
#import "EFLLessonCollectionViewCell.h"

@interface UREFLViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView                  *lessionCardCollectView;
@property (nonatomic, strong) NSArray<EFLLessonInfoModel *>     *infoModel;

@end

@implementation UREFLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self loadLessionConfig];
    [self initSubViews];
    [self initTableViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infoModel.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EFLLessonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardIndentifier" forIndexPath:indexPath];
    if (indexPath.row < self.infoModel.count) {
        cell.infoModel = [self.infoModel objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.infoModel.count) {
        
        EFLLessonInfoModel *model = [self.infoModel objectAtIndex:indexPath.row];
        if ([model.lessonId isEqualToString:@"simpleDialoug"]) {
            jumpViewController(@"URAudioLearnViewController");
        }
        else if ([model.lessonId isEqualToString:@"BBCSpecial"]) {
            
        }
    }
}

#pragma mark - init

- (void)initSubViews
{
    UIImageView *introductImage = [[UIImageView alloc] init];
    [self.view addSubview:introductImage];
    introductImage.image = [UIImage imageWithContentsOfFile:[URPathConfig loadNSBundleResurce:@"introduct_logo.jpg"]];
    [introductImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.top.mas_equalTo(150);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    UILabel *label =  [[UILabel alloc] init];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.text = @"hi，选择课程开始吧~ \n go!";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(introductImage.mas_trailing).mas_offset(containSpace);
        make.top.mas_equalTo(introductImage.mas_top).mas_offset(50);
        make.trailing.mas_equalTo(self.view).mas_offset(-containSpace);
        make.height.mas_equalTo(20);
    }];
}

- (void)initTableViews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 80, 220);
    layout.minimumLineSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(15, 40, 15, 40);
    
    self.lessionCardCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.lessionCardCollectView.delegate = self;
    self.lessionCardCollectView.dataSource = self;
    [self.view addSubview:self.lessionCardCollectView];
    self.lessionCardCollectView.backgroundColor = [UIColor whiteColor];
    
    [self.lessionCardCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_offset(100);
        make.height.mas_equalTo(250);
    }];
    
    [self.lessionCardCollectView registerClass:[EFLLessonCollectionViewCell class] forCellWithReuseIdentifier:@"cardIndentifier"];
}

- (void)loadLessionConfig
{
    self.infoModel = [EFLLessonUtils parserLessonJson];
}

@end
