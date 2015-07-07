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
	NSURL *testVideoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TestTalkingHead" ofType:@"mov"]];
	NSURL *testVideo2URL = [NSURL URLWithString:@"http://content.uplynk.com/468ba4d137a44f7dab3ad028915d6276.m3u8"];
	self.testVideoBadge.videoURL = testVideoURL;
	self.testVideoBillboard.videoURL = testVideo2URL;
	self.testVideoBadge.billboard = self.testVideoBillboard;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
