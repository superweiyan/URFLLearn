//
//  URNCEDownloadTableViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/11.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEDownloadTableViewCell.h"
#import "Masonry.h"
#import "URNCEType.h"

@interface URNCEDownloadTableViewCell()

@property (nonatomic, strong) UIImageView       *downloadFlagImage;
@property (nonatomic, strong) UIProgressView    *downloadProgressView;
@property (nonatomic, strong) UILabel           *tipLabel;

@end

@implementation URNCEDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.downloadProgressView = [[UIProgressView alloc] init];
        self.downloadProgressView.progressTintColor = [UIColor yellowColor];
        self.downloadProgressView.trackTintColor = [UIColor whiteColor];
        [self addSubview:self.downloadProgressView];

        self.downloadFlagImage = [[UIImageView alloc] init];
        self.downloadFlagImage.contentMode = UIViewContentModeScaleAspectFit;
        self.downloadFlagImage.backgroundColor = [UIColor redColor];
        [self addSubview:self.downloadFlagImage];
        
        self.tipLabel = [[UILabel alloc] init];
        [self addSubview:self.tipLabel];
        
        [self initNotification];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadProgressNotification:)
                                                 name:kDownloadProgressNotification
                                               object:nil];
}

- (void)setTipName:(NSString *)tipName
{
    _tipName = tipName;
    self.tipLabel.text = tipName;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    [self.downloadProgressView setProgress:progressValue animated:YES];
}

- (void)updateConstraints
{
    [self.downloadFlagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50)).priority(MASLayoutPriorityDefaultLow);
    }];
    
    [self.downloadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).mas_offset(50);
        make.trailing.mas_equalTo(self).mas_offset(-50);
        make.top.and.bottom.mas_equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - notification

- (void)downloadProgressNotification:(NSNotification *)notification
{
    NSString *url = [notification.userInfo objectForKey:@"url"];
    NSNumber *progressNumber = [notification.userInfo objectForKey:@"progress"];
    
    if ([url isEqualToString:self.url]) {
        self.progressValue = progressNumber.floatValue;
    }
}

@end
