//
//  URNCEDownloadTableViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/6/11.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URNCEDownloadTableViewCell.h"
#import "Masonry.h"

@interface URNCEDownloadTableViewCell()

@property (nonatomic, strong) UIImageView  *downloadFlagImage;

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
        self.downloadFlagImage = [[UIImageView alloc] init];
        self.downloadFlagImage.contentMode = UIViewContentModeScaleAspectFit;
        self.downloadFlagImage.backgroundColor = [UIColor redColor];
        [self addSubview:self.downloadFlagImage];
        
        [self.downloadFlagImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.trailing.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return self;
}

@end
