//
//  AVCCircleProgressIndicator.m
//  Portfolio
//
//  Created by Aaron Corsi on 7/6/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCCircleProgressIndicator.h"

@implementation AVCCircleProgressIndicator

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
		[self configure];
    }
    return self;
}

- (void)configure {
	// Playback Indicator
	self.circlePlaybackIndicatorLayer = [CAShapeLayer layer];
	self.circlePlaybackIndicatorLayer.frame = self.bounds;
	self.circlePlaybackIndicatorLayer.lineWidth = 2;
	self.circlePlaybackIndicatorLayer.fillColor = [[UIColor clearColor] CGColor];
	//self.circlePlaybackIndicatorLayer.strokeColor = [[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1] CGColor];
	self.circlePlaybackIndicatorLayer.strokeColor = [[UIColor redColor] CGColor];
	//	CGMutablePathRef circlePath = CGPathCreateMutable();
	//	CGPathAddEllipseInRect(circlePath, NULL, CGRectInset(self.layer.bounds, 0, 0));
	//	self.circlePlaybackIndicatorLayer.path = circlePath;
	//	CGPathRelease(circlePath);
	[self.layer addSublayer:self.circlePlaybackIndicatorLayer];
}

#pragma mark - Drawing

- (UIBezierPath *)circlePath {
	return [UIBezierPath bezierPathWithOvalInRect:[self circleFrame]];
}

- (CGRect)circleFrame {
	CGRect circleFrame = CGRectMake(0, 0, 2 * self.circlePlaybackIndicatorRadius, 2 * self.circlePlaybackIndicatorRadius);
	circleFrame.origin.x = CGRectGetMidX(self.circlePlaybackIndicatorLayer.bounds) - CGRectGetMidX(circleFrame);
	circleFrame.origin.y = CGRectGetMidY(self.circlePlaybackIndicatorLayer.bounds) - CGRectGetMidY(circleFrame);
	return circleFrame;
}

@end
