//
//  URNCEViewController.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/9.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEViewController.h"
#import "Masonry.h"
#import "URNCEVolumeCollectionViewCell.h"
#import "URNCEInfoViewController.h"
#import "URNCEDownloadViewController.h"

@interface URNCEViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *lessionCollection;
@property (nonatomic, strong) NSArray<NSString *> *volumesArray;

@end

@implementation URNCEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen mainScreen].bounds.size.height - 64)/2);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.lessionCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.lessionCollection.delegate = self;
    self.lessionCollection.dataSource = self;
    self.lessionCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lessionCollection];
    
    [self.lessionCollection registerClass:[URNCEVolumeCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellIndetifer"];
    
    [self.lessionCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.volumesArray = @[@"http://image-1.verycd.com/20cc046915cbcb5b47cae14176edb8ed174877(600x)/thumb.jpg",
                          @"http://www.gs-xbsc.com/Upfile_bookpic/154_1.jpg",
                          @"http://www.en8848.com.cn/d/file/soft/Nonfiction/Study/201109/bd6fd7beb0f0461f28de07fca373ed12.jpg",
                          @"http://www.en8848.com.cn/d/file/soft/Nonfiction/Study/201109/531c9039f84989a50d26b00ee11b382a.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    URNCEVolumeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellIndetifer" forIndexPath:indexPath];
    NSString *logoUrl = [self.volumesArray objectAtIndex:indexPath.row];
    cell.logoUrl = logoUrl;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    URNCEDownloadViewController *controller = [[URNCEDownloadViewController alloc] init];
    controller.volumeInfo = @[@"http://makefriends.bs2dl.yy.com/NCE1_1.zip",
                              @"http://makefriends.bs2dl.yy.com/NCE1_2.zip",
                              @"http://makefriends.bs2dl.yy.com/NCE1_3.zip",
                              @"http://makefriends.bs2dl.yy.com/NCE1_4.zip"];
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
