//
//  URAudioInfoView.m
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/2.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import "URAudioInfoView.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface URAudioInfoView()

@property (nonatomic, strong) UIButton  *playBtn;               //开始/暂停
@property (nonatomic, strong) UIButton  *volumeControlBtn;      //声音大小
@property (nonatomic, strong) UIView    *progressView;          //播放进度
@property (nonatomic, strong) UIButton  *infPlayConfigBtn;      //无限循环按钮

@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) AVPlayerItem  *playItem;
@property (nonatomic, strong) id            timeObser;
@property (nonatomic, assign) BOOL          isInfPlay;
@property (nonatomic, strong) UISlider      *sider;
@property (nonatomic, assign) CGFloat       currentVolumeValue;

@end

@implementation URAudioInfoView

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
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initData];
        [self initViews];
        [self initNotification];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playAudio:(NSString *)path
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"2272395.MP3" ofType:nil];
    if (audioPath.length > 0) {
        self.playItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:audioPath]];
    }
    else {
        self.playItem = nil;
    }
}

#pragma mark - action

- (void)onvolumeControlClicked:(id)sender
{
    if (self.sider) {
        [self.sider removeFromSuperview];
        self.sider = nil;
    }
    else {
        self.sider = [[UISlider alloc] init];
        self.sider.minimumValue = 0.0;
        self.sider.maximumValue = 1.0;
        self.sider.value = self.currentVolumeValue;
        [self.sider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [[UIApplication sharedApplication].keyWindow addSubview:self.sider];
        [self.sider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).mas_offset(40);
            make.trailing.mas_equalTo(self).mas_offset(-40);
            make.height.mas_equalTo(15);
            make.bottom.mas_equalTo(self).mas_offset(-60);
        }];
    }
}

- (void)sliderValueChanged:(id)sender
{
    UISlider *control = (UISlider *)sender;
    if(control == self.sider){
        self.currentVolumeValue = control.value;
        self.player.volume = self.currentVolumeValue;
    }
}

- (void)onPlayClicked:(id)sender
{
    [self addAudioObserver];
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
    [self.player play];
}

- (void)onInfPlayClicked:(id)sender
{
    self.isInfPlay = !self.isInfPlay;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayer Ready to Play");
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

// 播放结束的时候，会调用这个通知
- (void)onPlayFinishNotification:(NSNotification *)notification
{
    if (self.isInfPlay) {
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
    else {
        [self removeAudioObserver];
    }
}

- (void)addAudioObserver
{
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)removeAudioObserver
{
    [self.player removeObserver:self forKeyPath:@"status"];
}
#pragma mark - init

- (AVPlayer *)player
{
    if(!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = self.currentVolumeValue;
    }
    return _player;
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlayFinishNotification:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)initData
{
    self.isInfPlay = NO;
    self.currentVolumeValue = 0.5;
}

- (void)initViews
{
    self.playBtn = [[UIButton alloc] init];
    [self addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(onPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.backgroundColor = [UIColor redColor];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.volumeControlBtn = [[UIButton alloc] init];
    [self.volumeControlBtn addTarget:self action:@selector(onvolumeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.volumeControlBtn.backgroundColor = [UIColor blueColor];
    [self addSubview:self.volumeControlBtn];
    
    [self.volumeControlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.playBtn.mas_trailing).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.infPlayConfigBtn = [[UIButton alloc] init];
    [self.infPlayConfigBtn addTarget:self action:@selector(onInfPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.infPlayConfigBtn];
    
    [self.infPlayConfigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.volumeControlBtn.mas_trailing).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(self);
    }];

    self.progressView = [[UIView alloc] init];
    self.progressView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.infPlayConfigBtn.mas_trailing).mas_offset(10);
        make.trailing.mas_equalTo(self).mas_offset(-10);
        make.height.mas_equalTo(30);
    }];
}


@end
