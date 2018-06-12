//
//  URNCEVolumeCollectionViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/9.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEVolumeCollectionViewCell.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"

@interface URNCEVolumeCollectionViewCell()

@property (nonatomic, strong) UIImageView       *logoImage;

@end

@implementation URNCEVolumeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.logoImage = [[UIImageView alloc] init];
        self.logoImage.clipsToBounds = YES;
        [self addSubview:self.logoImage];
        self.logoImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)updateConstraints
{
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.leading.mas_equalTo(self).mas_offset(10);
        make.trailing.mas_equalTo(self).mas_offset(-10);
        make.bottom.mas_equalTo(self).mas_offset(-20);
    }];
    [super updateConstraints];
}

- (void)setLogoUrl:(NSString *)logoUrl
{
    _logoUrl = logoUrl;
    [self.logoImage setImageWithURL:[NSURL URLWithString:logoUrl]];
}
@end
