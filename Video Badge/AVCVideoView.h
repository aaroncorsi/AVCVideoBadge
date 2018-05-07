//
//  AVCVideoCalloutPlayerView.h
//  Portfolio
//
//  Created by Aaron Corsi on 7/3/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVPlayer;

@protocol AVCVideoViewDelegate <NSObject>

- (void)setVideoThumbnail:(UIImage *)image;
- (void)didChangeProgress:(double)progress;
- (void)videoDidReachEnd;

@end

@interface AVCVideoView : UIView

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *videoLayer;
@property (nonatomic, readonly) CMTime videoDuration;
@property (nonatomic) double playbackProgress;
@property (nonatomic) BOOL playing;
@property (nonatomic, weak) id timeObserver;

@property (nonatomic, weak) id<AVCVideoViewDelegate> delegate;

- (void)play;
- (void)pause;
- (void)stop;
- (void)playWithRate:(float)playbackRate;
- (void)resetPlaybackPosition;
- (void)setPlayer:(AVPlayer *)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
