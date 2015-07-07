//
//  AVCVideoCalloutView.h
//  Portfolio
//
//  Created by Aaron Corsi on 6/30/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCVideoController.h"

@class AVCCircleProgressIndicator;
@class AVCVideoBillboard;

@interface AVCVideoBadge : AVCVideoController

@property (nonatomic, weak) AVCVideoBillboard *billboard;
@property (nonatomic, strong) AVCCircleProgressIndicator *progressIndicator;

@end
