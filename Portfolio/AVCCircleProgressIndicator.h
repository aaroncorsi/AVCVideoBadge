//
//  AVCCircleProgressIndicator.h
//  Portfolio
//
//  Created by Aaron Corsi on 7/6/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVCCircleProgressIndicator : UIView

// Configuration
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat progressWidth;
@property (nonatomic) CGFloat trackWidth;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *trackTintColor;

@end
