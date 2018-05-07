//
//  AVCVideoCalloutPlayerView.m
//  Portfolio
//
//  Created by Aaron Corsi on 7/3/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCVideoView.h"
#import <AVFoundation/AVFoundation.h>

static void *AVCVideoViewRateObservationContext = &AVCVideoViewRateObservationContext;
static void *AVCVideoViewStatusObservationContext = &AVCVideoViewStatusObservationContext;
static void *AVCVideoViewPlayerDidReachEndObservationContext = &AVCVideoViewPlayerDidReachEndObservationContext;

@interface AVCVideoView ()


@end

@implementation AVCVideoView

#pragma mark - Video playback required methods

+ (Class)layerClass {
	return [AVPlayerLayer class];
}

- (void)setVideoFillMode:(NSString *)fillMode {
	AVPlayerLayer *playerLayer = (AVPlayerLayer *)[self layer];
	playerLayer.videoGravity = fillMode;
}


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
		
    }
    return self;
}

#pragma mark - Accessors

- (AVPlayer *)player {
	return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    dispatch_async(dispatch_get_main_queue(), ^{
        [(AVPlayerLayer *)[self layer] setPlayer:player];
    });
}

- (void)setVideoURL:(NSURL *)videoURL {
	_videoURL = videoURL;
	NSArray *assetKeys = @[@"duration", @"playable", @"tracks"];
	self.asset = [AVURLAsset assetWithURL:videoURL];
	
	[self.asset loadValuesAsynchronouslyForKeys:assetKeys completionHandler:^() {
		for (NSString *assetKey in assetKeys) {
			NSError *error = nil;
			AVKeyValueStatus keyStatus = [self.asset statusOfValueForKey:assetKey error:&error];
			
			if (keyStatus == AVKeyValueStatusFailed) {
				NSLog(@"Asset %@ failed to load key %@!", self.asset, assetKey);
				NSLog(@"Error: %@", error.localizedDescription);
			} 
			
			if ([assetKey isEqualToString:@"playable"]) {
				if (keyStatus == AVKeyValueStatusLoaded) {
					if (self.asset.playable) {
						// Video is playable
						// Make a thumbnail from the first frame of video
						if ([self.asset tracksWithMediaType:AVMediaTypeVideo] > 0) {
							NSError *imageGeneratorError = nil;
							AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
							UIImage *generatedThumbnail = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(0, 1) actualTime:nil error:&imageGeneratorError]];
							if (!imageGeneratorError) {
								[self.delegate setVideoThumbnail:generatedThumbnail];
							} else {
								NSLog(@"Error generating video thumbnail: %@", imageGeneratorError.localizedDescription);
							}
						}
						
						// Set up the player
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
                            self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                            [self.videoLayer setPlayer:self.player];
                            
                            self.videoLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                            [self setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
                            [self.layer addSublayer:self.videoLayer];
                            
                            // Time observer to update progress indicator
                            __weak AVCVideoView *weakSelf = self;
                            self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time){
                                [weakSelf updatePlaybackProgress];
                            }];
                        });
                        
                        // Listen for video to reach end
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidReachEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
					} else {
						NSLog(@"Video is not playable!");
					}
				}
			}
		}
	}];
}

- (CMTime)videoDuration {
	if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
		return self.playerItem.duration;
	} else {
		return kCMTimeInvalid;
	}
}

- (void)updatePlaybackProgress {
	NSLog(@"Updating progress");
	double currentTime = CMTimeGetSeconds(self.player.currentTime);
	double totalDuration = CMTimeGetSeconds([self videoDuration]);
	_playbackProgress = (currentTime / totalDuration);
	[self.delegate didChangeProgress:self.playbackProgress];
}

#pragma mark - Video Playback

- (BOOL)playing {
	return (self.player.rate == 0);
}

- (void)play {
	[self.player play];
}

- (void)playWithRate:(float)playbackRate {
	self.player.rate = playbackRate;
}

- (void)pause {
	[self.player pause];
}

- (void)stop {
	[self pause];
	[self resetPlaybackPosition];
}

- (void)resetPlaybackPosition {
	[self.player seekToTime:CMTimeMakeWithSeconds(0, 1)];
}

- (void)videoDidReachEnd {
	if (self.delegate) {
		[self.delegate videoDidReachEnd];
	} else {
		[self stop];
	}
}

#pragma mark - Key value observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == AVCVideoViewPlayerDidReachEndObservationContext) {
		
	} else if (context == AVCVideoViewRateObservationContext) {
		
	} else if (context == AVCVideoViewStatusObservationContext) {
		
	}
}

@end
