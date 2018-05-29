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
#import "URCommonMarco.h"

@interface URAudioInfoView()

@property (nonatomic, strong) UIButton      *playBtn;               //开始/暂停
@property (nonatomic, strong) UISlider      *progressSlider;        //播放进度
@property (nonatomic, strong) UISwitch      *infPlaySwitch;         //无限循环按钮

@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) AVPlayerItem  *playItem;
@property (nonatomic, strong) id            timeObser;
@property (nonatomic, assign) BOOL          isInfPlay;
@property (nonatomic, strong) UISlider      *volumeSlider;
@property (nonatomic, assign) CGFloat       currentVolumeValue;

@property (nonatomic, assign) BOOL          isPause;
@property (nonatomic, strong) id            playerObserve;
@property (nonatomic, assign) CGFloat       totalAudioSeconds;
@property (nonatomic, assign) BOOL          isKVO;

@end

@implementation URAudioInfoView

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
    if(self.playerObserve) {
        [self.player removeTimeObserver:self.playerObserve];
    }
    
    [self removeAudioObserver];
}

- (void)playAudio:(NSString *)path
{
    if (path.length > 0) {
        self.playItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
        
        CMTime duration = self.playItem.asset.duration;
        self.totalAudioSeconds = CMTimeGetSeconds(duration);
    }
    else {
        self.playItem = nil;
    }
}

#pragma mark - action

- (void)onProgressSliderClicked:(id)sender
{
    UISlider *control = (UISlider *)sender;
    
    if(control == self.progressSlider){
        
        CGFloat currentTime = self.totalAudioSeconds * self.progressSlider.value;
        
        [self.player seekToTime:CMTimeMake(currentTime, 1) completionHandler:^(BOOL finished) {
            
        }];
    }
}

- (void)onvolumeControlClicked:(id)sender
{
    if (self.volumeSlider) {
        [self.volumeSlider removeFromSuperview];
        self.volumeSlider = nil;
    }
}

- (void)sliderValueChanged:(id)sender
{
    UISlider *control = (UISlider *)sender;
    if(control == self.volumeSlider){
        self.currentVolumeValue = control.value;
        self.player.volume = self.currentVolumeValue;
    }
}

- (void)onPlayClicked:(id)sender
{
    if(self.player.rate == 1) {
        [self.player pause];
        self.isPause = YES;
        [self.playBtn setImage:[UIImage imageNamed:@"player_6"] forState:UIControlStateNormal];
    }
    else {
        if (!self.isPause) {
            [self addAudioObserver];
            [self.player replaceCurrentItemWithPlayerItem:self.playItem];
        }
        [self.player play];
        [self.playBtn setImage:[UIImage imageNamed:@"player_4"] forState:UIControlStateNormal];
    }
}

- (void)onInfPlayClicked:(id)sender
{
    UISwitch* control = (UISwitch*)sender;
    if(control == sender){
        self.isInfPlay = control.on;
    }
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
    self.isPause = NO;
    [self.player seekToTime:kCMTimeZero];
    if (self.isInfPlay) {
        [self.player play];
    }
    else {
        [self removeAudioObserver];
        [self.playBtn setImage:[UIImage imageNamed:@"player_6"] forState:UIControlStateNormal];
    }
}

- (void)addAudioObserver
{
    if (!self.isKVO) {
        self.isKVO = YES;
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    }
    
}

- (void)removeAudioObserver
{
    if(self.isKVO) {
        self.isKVO = NO;
        [self.player removeObserver:self forKeyPath:@"status"];
    }
}

#pragma mark - slider

- (void)updateProgressSlider:(CGFloat)rate
{
    [self.progressSlider setValue:rate];
}

- (void)handleSlide:(UISlider *)slider
{
    
}

#pragma mark - init

- (AVPlayer *)player
{
    if(!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = self.currentVolumeValue;
        
        CMTime interval = CMTimeMake(1, 1);
        
        WeakSelf
        //这个方法就是每隔多久调用一次block，函数返回的id类型的对象在不使用时用-removeTimeObserver:释放，官方api是这样说的
        _playerObserve = [_player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            CGFloat currentTime = CMTimeGetSeconds(time);

            if (self.totalAudioSeconds == 0) {
                CMTime totalTime = weakSelf.player.currentItem.duration;
                weakSelf.totalAudioSeconds = CMTimeGetSeconds(totalTime);
            }

            CGFloat rate = currentTime / self.totalAudioSeconds;
            [weakSelf updateProgressSlider:rate];

        }];
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
    [self.playBtn setImage:[UIImage imageNamed:@"player_6"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(onPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.infPlaySwitch = [[UISwitch alloc] init];
    [self.infPlaySwitch addTarget:self action:@selector(onInfPlayClicked:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.infPlaySwitch];
    
    [self.infPlaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.playBtn.mas_trailing).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.mas_equalTo(self);
    }];
    
    self.volumeSlider = [[UISlider alloc] init];
    self.volumeSlider.minimumValue = 0.0;
    self.volumeSlider.maximumValue = 1.0;
    self.volumeSlider.value = self.currentVolumeValue;
    [self.volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.volumeSlider];
    
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.trailing.mas_equalTo(self).mas_offset(-10);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    UIView *spliteView = [[UIView alloc] init];
    spliteView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:spliteView];
    
    [spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(1);
        make.trailing.mas_equalTo(self.volumeSlider.mas_leading).mas_offset(-5);
    }];
    
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];

    self.progressSlider = [[UISlider alloc] init];
    [self.progressSlider addTarget:self action:@selector(onProgressSliderClicked:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.progressSlider];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(self.infPlaySwitch.mas_trailing).mas_offset(10);
        make.trailing.mas_equalTo(spliteView.mas_leading).mas_offset(-5);
        make.height.mas_equalTo(30);
    }];
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
}


@end
