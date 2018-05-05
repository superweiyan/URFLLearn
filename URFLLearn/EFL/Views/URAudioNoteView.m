//
//  URAudioNoteView.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/4.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URAudioNoteView.h"
#import "Masonry.h"
#import "URLayoutConfig.h"
#import "EFLTypes.h"

@interface URAudioNoteView()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation URAudioNoteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.closeBtn = [[UIButton alloc] init];
        [self.closeBtn addTarget:self action:@selector(onSwitchViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn setTitle:@"收起" forState:UIControlStateNormal];
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.closeBtn];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(viewTop);
            make.trailing.mas_equalTo(self).mas_offset(-viewLeading);
            make.size.mas_equalTo(CGSizeMake(50, 20));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"关键词组";
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).mas_offset(viewLeading);
            make.top.mas_equalTo(self).mas_offset(viewTop);
            make.height.mas_equalTo(20);
            make.trailing.mas_equalTo(self.closeBtn.mas_leading).mas_offset(-viewSpace);
        }];
        
        [label setMas_key:@"keyword"];
        
        self.textView = [[UITextView alloc] init];
        self.textView.editable = NO;
        [self addSubview:self.textView];
        
        [self.textView setMas_key:@"text"];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).mas_offset(viewLeading);
            make.top.mas_equalTo(label.mas_bottom).mas_offset(viewTop);
            make.trailing.mas_equalTo(self).mas_offset(-viewLeading);
            make.height.mas_equalTo(65);
        }];
    }
    
    return self;
}

- (void)setAudioModel:(EFLAudioModel *)audioModel
{
    _audioModel = audioModel;
    
    NSMutableString *txt = [[NSMutableString alloc] init];
    [txt appendString:[self checkString:_audioModel.keyWord]];
    [txt appendString:@"\n"];
    [txt appendString:[self checkString:_audioModel.chineseWord]];
    [txt appendString:@"\n"];
    
    for (int i = 0; i < _audioModel.exampleSentences.count; i++) {
        EFLAudioExampleModel *example = [_audioModel.exampleSentences objectAtIndex:i];
        [txt appendString:[self checkString:example.englist]];
        [txt appendString:@"\n"];
        [txt appendString:[self checkString:example.chinese]];
    }
    self.textView.text = txt;
}

- (void)onSwitchViewClicked:(id)sender
{
    if (self.audioNoteCallbaak) {
        self.audioNoteCallbaak();
    }
}

- (NSString *)checkString:(NSString *)txt
{
    if (txt.length == 0) {
        return @"";
    }
    return txt;
}

@end
