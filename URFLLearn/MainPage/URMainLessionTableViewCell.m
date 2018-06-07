//
//  URMainLessionTableViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/7.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URMainLessionTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+AFNetworking.h"
#import "URCommonMarco.h"
#import "NSObject+modelHeight.h"
#import "URMainType.h"

@interface URMainLessionTableViewCell()

@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIImageView           *bgImageView;

@end

@implementation URMainLessionTableViewCell

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
        
        self.bgImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView).mas_offset(15);
            make.trailing.mas_equalTo(self.contentView).mas_offset(-15);
            make.top.mas_equalTo(self.contentView).mas_offset(10);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 200));
            make.center.mas_equalTo(self.contentView);
        }];

    }
    return self;
}

- (void)setItem:(URMainSuggestionItem *)item
{
    _item = item;
    
    self.titleLabel.text = item.name;
    
    WeakSelf
    
    [self.bgImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.logoUrl]]
                            placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                CGSize imageSize = image.size;
                                weakSelf.bgImageView.image = image;
                                
                                [weakSelf.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                                    make.height.mas_equalTo(imageSize.height);
                                }];
                                
                                [weakSelf updateItemHeight:imageSize.height];
                                
                                if ([weakSelf.cellDelegate respondsToSelector:@selector(needUpdateConstraintCell)]) {
                                    [weakSelf.cellDelegate needUpdateConstraintCell];
                                }
                            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                
                            }];

}

- (void)updateItemHeight:(CGFloat)height
{
    self.item.modelHeight = (height + 20);
}

@end
