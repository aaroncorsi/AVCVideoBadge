//
//  AVCVideoCalloutView.m
//  Portfolio
//
//  Created by Aaron Corsi on 6/30/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCVideoBadge.h"
#import "AVCVideoBillboard.h"
#import "AVCCircleProgressIndicator.h"

@interface AVCVideoBadge ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic) BOOL snapEnabled;

@end

@implementation AVCVideoBadge

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

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.thumbnailImageView) {
		self.thumbnailImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	}
}

#pragma mark Configuration

- (void)configure {
	[super configure];
	// Set default corner offset
	self.cornerOffset = CGPointMake(0, 0);
	
	// Set mask
	self.maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VideoBadgeMask"]];
	self.backgroundColor = [UIColor clearColor];
	
	// Progress indicator
	self.progressIndicator = [[AVCCircleProgressIndicator alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4)];
	self.progressIndicator.progress = 0;
	[self addSubview:self.progressIndicator];
	
	// Setup pan and snap
	self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[self addGestureRecognizer:self.panRecognizer];
	[self setupSnapBehavior];
}

- (CGPoint)snapPoint {
	if (self.billboard) {
		NSLog(@"Frame at time of snap point: X%f Y%f W%f H%f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		return CGPointMake((self.billboard.frame.origin.x + self.billboard.frame.size.width) + self.cornerOffset.x, (self.billboard.frame.origin.y + self.billboard.frame.size.height) + self.cornerOffset.y);
	} else {
		return CGPointMake(self.center.x + self.cornerOffset.x, self.center.y + self.cornerOffset.y);
	}
}

- (void)setupSnapBehavior {
	if (!self.animator) {
		self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
	}
	if (self.snapBehavior) {
		self.snapEnabled = NO;
	}
	// Setup new snap behavior
	self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:[self snapPoint]];
	self.snapBehavior.damping = 0.7;
	self.snapEnabled = YES;
}

#pragma mark - Accessors

- (void)setBillboard:(AVCVideoBillboard *)billboard {
	_billboard = billboard;
	self.billboard.playbackControlEnabled = NO;
	[self setupSnapBehavior];
}

- (void)setSnapEnabled:(BOOL)snapEnabled {
	if (self.snapBehavior && self.animator) {
		_snapEnabled = snapEnabled;
		if (self.snapEnabled) {
			[self.animator addBehavior:self.snapBehavior];
		} else {
			[self.animator removeBehavior:self.snapBehavior];
		}
	} else {
		_snapEnabled = NO;
		NSLog(@"Could not enable snap because animator or behavior are nil");
	}
}

- (void)setPlaybackProgress:(CGFloat)playbackProgress {
	[super setPlaybackProgress:playbackProgress];
	self.progressIndicator.progress = self.playbackProgress;
}

#pragma mark - Playback controls

- (void)play {
	[super play];
	if (self.billboard) {
		[self.billboard play];
	}
}

- (void)pause {
	[super pause];
	if (self.billboard) {
		[self.billboard pause];
	}
}

- (void)stop {
	NSLog(@"VideoView: %@", self.videoPlayerView);
	NSLog(@"VideoThumbnail: %@", self.thumbnailImageView);
	if (self.billboard) {
		[self.billboard stop];
	}
	[super stop];
}

- (void)playWithRate:(float)playbackRate {
	float previousRate = self.videoPlayerView.player.rate;
	[super playWithRate:playbackRate];
	if (self.billboard) {
		[self.billboard playWithRate:playbackRate];
		
		// If finishing a fast forward, sync the playback position
		if (playbackRate == 1 && previousRate > 1) {
			[self.billboard.videoPlayerView.player seekToTime:self.videoPlayerView.player.currentTime];
		}
	}
}

#pragma mark Progress view

- (void)syncProgressView {
	self.progressIndicator.progress = self.videoPlayerView.playbackProgress;
	[self.progressIndicator layoutSubviews];
}

#pragma mark - Gestures

- (void)didPan:(UIPanGestureRecognizer *)panRecognizer {
	static CGPoint startCenter;
	if (panRecognizer.state == UIGestureRecognizerStateBegan) {
		startCenter = panRecognizer.view.center;
		self.snapEnabled = NO;
	} else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
		CGPoint translation = [panRecognizer translationInView:self.superview];
		self.center = CGPointMake(startCenter.x + translation.x, startCenter.y + translation.y);
	} else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
		self.snapEnabled = YES;
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

@end
