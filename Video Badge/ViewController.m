//
//  ViewController.m
//  Portfolio
//
//  Created by Aaron Corsi on 6/30/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSURL *testVideo2URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TestTalkingHeadLong" ofType:@"mov"]];
    NSURL *rushingRiverVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"RushingRiver" ofType:@"mov"]];
	self.testVideoBadge.videoURL = testVideo2URL;
	self.testVideoBadge.thumbnailImage = [UIImage imageNamed:@"Selfie.png"];
	self.testVideoBillboard.videoURL = rushingRiverVideoURL;
	self.testVideoBadge.billboard = self.testVideoBillboard;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
