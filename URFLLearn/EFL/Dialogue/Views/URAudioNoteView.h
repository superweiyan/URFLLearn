//
//  URAudioNoteView.h
//  URFLLearn
//
//  Created by lin weiyan on 2018/5/4.
//  Copyright © 2018 lin weiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFLAudioModel;

typedef void (^onAudioNoteClickedCallback)(void);

@interface URAudioNoteView : UIView

@property (nonatomic, strong) EFLAudioModel              *audioModel;
@property (nonatomic, copy) onAudioNoteClickedCallback   audioNoteCallbaak;

@property (nonatomic, assign) CGFloat                   expectHeight;

@end
