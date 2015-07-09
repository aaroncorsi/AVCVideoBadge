//
//  AVCVideoController.m
//  Portfolio
//
//  Created by Aaron Corsi on 7/5/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCVideoController.h"

@implementation AVCVideoController

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self configure];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self configure];
	}
	return self;
}

- (void)configure {
	self.playbackControlEnabled = YES;
	
	// Gesture Recognizers
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
	[self addGestureRecognizer:tapRecognizer];
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
	[self addGestureRecognizer:longPressRecognizer];
	
	// Video Player View
	self.videoPlayerView = [[AVCVideoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.videoPlayerView.delegate = self;
	[self addSubview:self.videoPlayerView];
}

# pragma mark - Accessors

- (NSURL *)videoURL {
	return self.videoPlayerView.videoURL;
}

- (void)setVideoURL:(NSURL *)videoURL {
	self.videoPlayerView.videoURL = videoURL;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
	_thumbnailImage = thumbnailImage;
	
	if (!self.thumbnailImageView) {
		self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
		[self insertSubview:self.thumbnailImageView belowSubview:self.videoPlayerView];
	}
	
	self.thumbnailImageView.image = self.thumbnailImage;
	
	if (!self.playing) {
		[self stop];
	}
}

- (void)setPlaybackProgress:(CGFloat)playbackProgress {
	self.videoPlayerView.playbackProgress = playbackProgress;
}

- (CGFloat)playbackProgress {
	return self.videoPlayerView.playbackProgress;
}

#pragma mark - Playback

- (BOOL)playing {
	return self.videoPlayerView.playing;
}

- (void)play {
	[self showPlayerAnimated:NO];
	[self.videoPlayerView play];
}

- (void)pause {
	[self.videoPlayerView pause];
}

- (void)stop {
	[self.videoPlayerView stop];
	[self hidePlayerAnimated:YES];
}

- (void)playWithRate:(float)playbackRate {
	[self.videoPlayerView playWithRate:playbackRate];
}

#pragma mark State Transitions

- (void)hidePlayerAnimated:(BOOL)animated {
	if (animated) {
		[UIView animateWithDuration:0.5 animations:^(void){
			if (self.thumbnailImageView.image) {
				NSLog(@"Thumbnail Image: %@", self.thumbnailImageView.image);
				self.videoPlayerView.alpha = 0;
			}
		}];
	} else {
		if (self.thumbnailImageView.image) {
			self.videoPlayerView.alpha = 0;
		}
	}
}

- (void)showPlayerAnimated:(BOOL)animated {
	if (animated) {
		[UIView animateWithDuration:0.2 animations:^(void){
			self.videoPlayerView.alpha = 1;
		}];
	} else {
		self.videoPlayerView.alpha = 1;
	}
}

#pragma mark - Gestures

- (void)didSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
	if (self.playbackControlEnabled) {
		if (self.videoPlayerView.player.rate > 0) {
			[self stop];
		} else if (self.videoPlayerView.player.rate == 0) {
			[self play];
		}
	}
}

- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (self.playbackControlEnabled && self.videoPlayerView.player.rate > 0) {
		if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
			[self playWithRate:2];
		} else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
			[self playWithRate:1];
		}
	}
}

#pragma mark - AVCVideoViewDelegate

- (void)didChangeProgress:(double)progress {
	self.playbackProgress = progress;
}

- (void)videoDidReachEnd {
	[self stop];
}

@end
