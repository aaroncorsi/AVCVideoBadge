//
//  AVCCircleProgressIndicator.m
//  Portfolio
//
//  Created by Aaron Corsi on 7/6/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCCircleProgressIndicator.h"

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface AVCCircleProgressIndicator ()

@property (nonatomic, readonly) CGFloat circleRadius;
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self configure];
	}
	return self;
}

- (void)configure {
	self.backgroundColor = [UIColor clearColor];
	
	// Create background ring
	self.trackLayer = [CAShapeLayer layer];
	self.trackLayer.frame = self.bounds;
	self.trackLayer.lineWidth = 4;
	self.trackLayer.fillColor = [[UIColor clearColor] CGColor];
	self.trackLayer.strokeColor = [[UIColor blackColor] CGColor];
	self.trackLayer.strokeEnd = 1;
	self.trackLayer.path = [self circlePath].CGPath;
	[self.layer addSublayer:self.trackLayer];
	
	// Creat playback Indicator
	self.progressLayer = [CAShapeLayer layer];
	self.progressLayer.frame = self.bounds;
	self.progressLayer.lineWidth = 1;
	self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
	self.progressLayer.strokeColor = [[UIColor colorWithHue:0 saturation:0 brightness:0.5 alpha:1] CGColor];
	self.progressLayer.path = [self circlePath].CGPath;
	[self.layer addSublayer:self.progressLayer];
	self.progress = 1;
}

#pragma mark - Accessors

- (CGFloat)circleRadius {
	return self.frame.size.height / 2;
}

- (CGFloat)progress {
	return self.progressLayer.strokeEnd;
}

- (void)setProgress:(CGFloat)progress {
	if (progress > 1) {
		self.progressLayer.strokeEnd = 1;
	} else if (progress < 0) {
		self.progressLayer.strokeEnd = 0;
	} else {
		self.progressLayer.strokeEnd = progress;
	}
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
	self.progressLayer.strokeColor = [progressTintColor CGColor];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
	self.trackLayer.strokeColor = [trackTintColor CGColor];
}

#pragma mark - Drawing

- (void)layoutSubviews {
	self.progressLayer.frame = self.bounds;
	self.trackLayer.frame = self.bounds;
	self.progressLayer.path = [self circlePath].CGPath;
}

//- (void)drawRect:(CGRect)rect {
//	[super drawRect:rect];
//	UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.frame.size.width / 2) startAngle:0 endAngle:DEGREES_TO_RADIANS(135) clockwise:YES];
//	//UIBezierPath *circlePath = [self circlePath];
//	circlePath.lineWidth = 2;
//	[[UIColor blackColor] setStroke];
//	CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
//	CGContextSaveGState(graphicsContext);
//	[circlePath stroke];
//	CGContextRestoreGState(graphicsContext);
//}

- (UIBezierPath *)circlePath {
	return [UIBezierPath bezierPathWithOvalInRect:[self circleFrame]];
}

- (CGRect)circleFrame {
	CGRect circleFrame = CGRectMake(0, 0, 2 * self.circleRadius, 2 * self.circleRadius);
	circleFrame.origin.x = CGRectGetMidX(self.progressLayer.bounds) - CGRectGetMidX(circleFrame);
	circleFrame.origin.y = CGRectGetMidY(self.progressLayer.bounds) - CGRectGetMidY(circleFrame);
	return circleFrame;
}

@end
