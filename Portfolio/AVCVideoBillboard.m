//
//  AVCVideoBillboard.m
//  Portfolio
//
//  Created by Aaron Corsi on 7/4/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCVideoBillboard.h"

@implementation AVCVideoBillboard

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.clipsToBounds = YES;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		self.clipsToBounds = YES;
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
