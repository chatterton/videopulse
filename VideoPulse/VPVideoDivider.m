//
//  VPVideoDivider.m
//  VideoPulse
//
//  Created by Jack Chatterton on 2/7/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VPVideoDivider.h"

@implementation VPVideoDivider {
    ImageCallback imageCallback;
    AVAssetImageGenerator *generator;
    float secondsIn;
    float durationSeconds;
    float interval;
    bool stopping;
}

- (void)startWithCallback:(ImageCallback)callback {
    stopping = false;
    imageCallback = callback;

    generator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    generator.appliesPreferredTrackTransform = YES;

    durationSeconds = CMTimeGetSeconds(self.asset.duration);
    secondsIn = 0.0;
    [self snapshotImage];
}

- (void)setDesiredFPS:(float)desiredFPS {
    interval = 1.0 / desiredFPS;
}

- (void)stop {
    stopping = true;
}

- (void)snapshotImage {

    CMTime time = CMTimeMake(secondsIn, 1);
    CGImageRef ref = [generator copyCGImageAtTime:time actualTime:nil error:nil];
    imageCallback(ref);
    CGImageRelease(ref);

    secondsIn += interval;
    if (secondsIn < durationSeconds && !stopping) {
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(snapshotImage)
                                       userInfo:nil
                                        repeats:NO];
    }
    if (stopping) {
        stopping = false;
    }
}

@end

