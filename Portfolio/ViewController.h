//
//  ViewController.h
//  Portfolio
//
//  Created by Aaron Corsi on 6/30/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCVideoBadge.h"
#import "AVCVideoBillboard.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet AVCVideoBadge *testVideoBadge;
@property (weak, nonatomic) IBOutlet AVCVideoBillboard *testVideoBillboard;

@end

