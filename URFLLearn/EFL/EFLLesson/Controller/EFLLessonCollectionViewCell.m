//
//  EFLLessonCollectionViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/29.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "EFLLessonCollectionViewCell.h"
#import "EFLTypes.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface EFLLessonCollectionViewCell()

@property (nonatomic, strong) UIImageView   *logoView;
@property (nonatomic, strong) UILabel       *lessonNameLabel;
@property (nonatomic, strong) CAGradientLayer *gradLayer;

@end

@implementation EFLLessonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.logoView = [[UIImageView alloc] init];
    [self addSubview:self.logoView];
    
    
    self.gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
                       nil];
    [self.gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [self.gradLayer setStartPoint:CGPointMake(0.5f, 0.0f)];
    [self.gradLayer setEndPoint:CGPointMake(0.5f, 1.0f)];

//    [self.logoView.layer setMask:self.gradLayer];
    
    [self.logoView.layer addSublayer:self.gradLayer];
    
    self.lessonNameLabel = [[UILabel alloc] init];
    self.lessonNameLabel.font = [UIFont systemFontOfSize:20];
    self.lessonNameLabel.textColor = [UIColor whiteColor];
    self.lessonNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lessonNameLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.gradLayer setFrame:self.logoView.bounds];
}

- (void)updateConstraints
{
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).mas_offset(5);
        make.trailing.mas_equalTo(self).mas_offset(-5);
        make.top.mas_equalTo(self).mas_offset(5);
        make.height.mas_equalTo(self).mas_offset(-5);
    }];

    
    [self.lessonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(-15);
        make.height.mas_equalTo(15);
        make.leading.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)setInfoModel:(EFLLessonInfoModel *)infoModel
{
    _infoModel = infoModel;
    [self.logoView setImageWithURL:[NSURL URLWithString:infoModel.logo]];
    self.lessonNameLabel.text = infoModel.lessonName;
}

@end
