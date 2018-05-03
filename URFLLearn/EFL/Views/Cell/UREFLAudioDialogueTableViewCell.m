//
//  UREFLAudioDialogueTableViewCell.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/3.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "UREFLAudioDialogueTableViewCell.h"

@interface UREFLAudioDialogueTableViewCell()

@property (nonatomic, strong) UIImageView   *portView;
@property (nonatomic, strong) UITextView    *textView;

@end

@implementation UREFLAudioDialogueTableViewCell

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
        [self addSubview:self.portView];
        
        self.textView = [[UITextView alloc] init];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)updateInfo:(NSString *)item  isOther:(BOOL)isOther
{
    
}

@end
