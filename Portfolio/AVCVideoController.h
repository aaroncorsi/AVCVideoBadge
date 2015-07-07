//
//  AVCVideoController.h
//  Portfolio
//
//  Created by Aaron Corsi on 7/5/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCVideoView.h"

@interface AVCVideoController : UIView <AVCVideoViewDelegate>

// Playback
@property (nonatomic) BOOL playbackControlEnabled;
@property (nonatomic, readonly) CGFloat playbackProgress;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) UIImage *videoThumbnail;

// Video Player
@property (nonatomic, strong) AVCVideoView *videoPlayerView;
@property (nonatomic, strong) UIImageView *thumbnailImageView;

- (void)play;
- (void)pause;
- (void)stop;
- (void)playWithRate:(float)playbackRate;
- (void)configure;

@end
