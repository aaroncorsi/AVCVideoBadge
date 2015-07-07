//
//  AVCVideoCalloutPlayerView.m
//  Portfolio
//
//  Created by Aaron Corsi on 7/3/15.
//  Copyright (c) 2015 Aaron Corsi. All rights reserved.
//

#import "AVCVideoView.h"
#import <AVFoundation/AVFoundation.h>

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
	[(AVPlayerLayer *)[self layer] setPlayer:player];
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
						self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
						self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
						[self.videoLayer setPlayer:self.player];
						self.videoLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
						[self setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
						[self.layer addSublayer:self.videoLayer];
						
						// Listen for video to reach end
						//[self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:nil];
						//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidReachEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
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

- (CGFloat)playbackProgress {
	double currentTime = CMTimeGetSeconds(self.player.currentTime);
	double totalDuration = CMTimeGetSeconds([self videoDuration]);
	return (CGFloat)(currentTime / totalDuration);
}

#pragma mark - Video Playback

- (void)videoDidReachEnd {
	[self resetPlaybackPosition];
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
	[self.player seekToTime:kCMTimeZero];
}

#pragma mark Scrubber

//-(void)initScrubberTimer
//{
//	double interval = .1f;
//	
//	CMTime playerDuration = [self playerItemDuration];
//	if (CMTIME_IS_INVALID(playerDuration))
//	{
//		return;
//	}
//	double duration = CMTimeGetSeconds(playerDuration);
//	if (isfinite(duration))
//	{
//		CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
//		interval = 0.5f * duration / width;
//	}
//	
//	/* Update the scrubber during normal playback. */
//	__weak AVPlayerDemoPlaybackViewController *weakSelf = self;
//	mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
//															   queue:NULL /* If you pass NULL, the main queue is used. */
//														  usingBlock:^(CMTime time)
//					 {
//						 [weakSelf syncScrubber];
//					 }];
//}

// Set the scrubber based on the player current time.
//- (void)syncScrubber
//{
//	CMTime playerDuration = [self playerItemDuration];
//	if (CMTIME_IS_INVALID(playerDuration))
//	{
//		mScrubber.minimumValue = 0.0;
//		return;
//	}
//	
//	double duration = CMTimeGetSeconds(playerDuration);
//	if (isfinite(duration))
//	{
//		float minValue = [self.mScrubber minimumValue];
//		float maxValue = [self.mScrubber maximumValue];
//		double time = CMTimeGetSeconds([self.mPlayer currentTime]);
//		
//		[self.mScrubber setValue:(maxValue - minValue) * time / duration + minValue];
//	}
//}

@end
