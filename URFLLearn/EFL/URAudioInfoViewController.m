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

@interface URAudioInfoViewController ()

@property (nonatomic, strong) URAudioInfoView   *infoView;
@property (nonatomic, strong) UITextView        *infoTextView;

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

- (void)initData
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"audioContext.txt" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:audioPath options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.infoTextView.text = str;
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
    
    self.infoTextView = [[UITextView alloc] init];
    self.infoTextView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.infoTextView];
    
    [self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationController.navigationBar.frame.size.height + 20 + 10);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-10);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
