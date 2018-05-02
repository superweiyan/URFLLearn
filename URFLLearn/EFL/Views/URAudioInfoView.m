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
@property (nonatomic, strong) UIView    *volumeControlBtn;      //声音大小
@property (nonatomic, strong) UIView    *progressView;          //播放进度
@property (nonatomic, strong) UIButton  *infPlayConfigBtn;      //无限循环按钮

@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) AVPlayerItem  *playItem;
@property (nonatomic, strong) id            timeObser;
@property (nonatomic, assign) BOOL          isInfPlay;

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

//#pragma mark - TimerObserver
//- (void)addVideoTimerObserver {
////    __weak typeof (self)self_ = self;
//     self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
////        float currentTimeValue = time.value*1.0/time.timescale/self_.videoLength;
////        NSString *currentString = [self.self_ getStringFromCMTime:time];
//    }];
//}
//- (void)removeVideoTimerObserver {
//    [_player removeTimeObserver:self.timeObser];
//}


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
    }
    return _player;
}

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlayFinishNotification:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)initData
{
    self.isInfPlay = NO;
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
    
    self.volumeControlBtn = [[UIView alloc] init];
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
