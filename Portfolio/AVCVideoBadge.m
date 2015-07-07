//
//  AVCVideoCalloutView.m
//  Portfolio
//
//  Created by Aaron Corsi on 6/30/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCVideoBadge.h"
#import "AVCVideoBillboard.h"

@interface AVCVideoBadge ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snap;
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
	if (self.billboard) {
		// Position badge in bottom right corner of billboard
		self.center = [self billboardCorner];
	}
}

#pragma mark Configuration

- (void)configure {
	[super configure];
	// Set mask
	self.maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VideoBadgeMask"]];
	
	// Setup pan gesture
	self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[self addGestureRecognizer:self.panRecognizer];
}

- (CGPoint)billboardCorner {
	return CGPointMake((self.billboard.frame.origin.x + self.billboard.frame.size.width) - self.frame.size.width / 3, (self.billboard.frame.origin.y + self.billboard.frame.size.height) - self.frame.size.height / 3);
}

#pragma mark - Accessors

- (void)setBillboard:(AVCVideoBillboard *)billboard {
	_billboard = billboard;
	self.billboard.playbackControlEnabled = NO;
	
	// Setup snap behavior
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
	self.snap = [[UISnapBehavior alloc] initWithItem:self snapToPoint:[self billboardCorner]];
	self.snap.damping = 0.7;
	self.snapEnabled = YES;
}

- (void)setSnapEnabled:(BOOL)snapEnabled {
	if (self.snap && self.animator) {
		_snapEnabled = snapEnabled;
		if (self.snapEnabled) {
			[self.animator addBehavior:self.snap];
		} else {
			[self.animator removeBehavior:self.snap];
		}
	} else {
		_snapEnabled = NO;
		NSLog(@"Could not enable snap because animator or behavior are nil");
	}
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
	[super stop];
	if (self.billboard) {
		[self.billboard stop];
	}
}

- (void)playWithRate:(float)playbackRate {
	[super playWithRate:playbackRate];
	if (self.billboard) {
		[self.billboard playWithRate:playbackRate];
	}
}

#pragma mark - Gestures

- (void)didPan:(UIPanGestureRecognizer *)panRecognizer {
	static CGPoint startCenter;
	if (panRecognizer.state == UIGestureRecognizerStateBegan) {
		NSLog(@"Pan Began");
		startCenter = panRecognizer.view.center;
		self.snapEnabled = NO;
	} else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
		CGPoint translation = [panRecognizer translationInView:self.superview];
		self.center = CGPointMake(startCenter.x + translation.x, startCenter.y + translation.y);
	} else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
		NSLog(@"Pan Ended");
		self.snapEnabled = YES;
	}
}

@end
