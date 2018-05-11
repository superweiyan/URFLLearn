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

@interface UREFLViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView                  *lessionCardCollectView;
@property (nonatomic, strong) NSArray<EFLLessionInfoModel *>    *infoModel;

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardIndentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.infoModel.count) {
        
        EFLLessionInfoModel *model = [self.infoModel objectAtIndex:indexPath.row];
        if ([model.lessionId isEqualToString:@"simpleDialoug"]) {
            jumpViewController(@"URAudioLearnViewController");
        }
        else if ([model.lessionId isEqualToString:@"BBCSpecial"]) {
            
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
    
    [self.lessionCardCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_offset(100);
        make.height.mas_equalTo(250);
    }];
    
    [self.lessionCardCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cardIndentifier"];
}

- (void)loadLessionConfig
{
    NSString *path = [URPathConfig loadNSBundleResurce:@"EFL.json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [str convertJson];
    [self parseDict:dict];
}

- (void)parseDict:(NSDictionary *)info
{
    if (![info isKindOfClass:[NSDictionary class]]) {
        return ;
    }

    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    NSArray *dataArray = [info objectForKey:@"datas"];
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *info = [dataArray objectAtIndex:i];
        EFLLessionInfoModel *model = [[EFLLessionInfoModel alloc] init];
        model.lessionName = [info objectForKey:@"name"];
        model.logo = [info objectForKey:@"logo"];
        model.note = [info objectForKey:@"description"];
        model.lessionId = [info objectForKey:@"lessionId"];
        
        [itemArray addObject:model];
    }
    
    self.infoModel = itemArray;
}

@end
