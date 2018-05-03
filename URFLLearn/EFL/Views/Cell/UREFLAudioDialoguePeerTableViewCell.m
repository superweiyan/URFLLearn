//
//  UREFLAudioDialoguePeerTableViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "UREFLAudioDialoguePeerTableViewCell.h"
#import "EFLTypes.h"
#import "Masonry.h"
#import "URLayoutConfig.h"

@interface UREFLAudioDialoguePeerTableViewCell()

@property (nonatomic, strong) UIImageView   *portView;
@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) UIImageView   *bubbleImageView;

@end

@implementation UREFLAudioDialoguePeerTableViewCell

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
        self.portView = [[UIImageView alloc] init];
        self.portView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.portView];
        
        self.bubbleImageView = [[UIImageView alloc] init];
        self.bubbleImageView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.bubbleImageView];
        
        self.textView = [[UITextView alloc] init];
        self.textView.scrollEnabled = NO;           //关键步骤
        self.textView.backgroundColor = [UIColor greenColor];
//        [self.textView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        [self.textView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.bubbleImageView addSubview:self.textView];
        
        
        [self.portView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(viewTop);
            make.trailing.mas_equalTo(self.contentView).mas_offset(-viewLeading);
            make.size.mas_equalTo(CGSizeMake(portraitNormal, portraitNormal));
        }];
        
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).mas_offset(viewTop);
            make.trailing.mas_equalTo(self.portView.mas_leading).mas_offset(-viewLeading);
            //            make.height.mas_equalTo(30);
            //            make.trailing.mas_equalTo(self.contentView).mas_offset(-40);
            //            make.trailing.mas_equalTo(self.textView.mas_trailing).mas_offset(-viewMarginLeading);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-viewBottom);
            make.leading.mas_greaterThanOrEqualTo(self.contentView);
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bubbleImageView).insets(UIEdgeInsetsMake(viewMarginTop + 5,
                                                                             viewMarginLeading,
                                                                             viewMarginLeading,
                                                                             viewMarginBottom));
            make.width.mas_lessThanOrEqualTo(self.contentView.frame.size.width * 0.6);
            
            //            make.top.mas_equalTo(self.bubbleImageView.mas_top).mas_offset(viewMarginTop);
            //            make.leading.mas_equalTo(self.bubbleImageView.mas_leading).mas_offset(viewMarginLeading);
            //            make.trailing.mas_equalTo(self.bubbleImageView.mas_trailing).mas_offset(-viewMarginLeading);
            //            make.bottom.mas_equalTo(self.contentView).mas_offset(viewMarginBottom + viewBottom);
        }];
    }
    return self;
}

- (void)setAudioModel:(EFLAudioModel *)audioModel
{
    _audioModel = audioModel;
    self.textView.text = audioModel.content;
}

@end
