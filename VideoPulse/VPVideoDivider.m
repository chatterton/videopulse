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
    int secondsIn;
    float durationSeconds;
}

- (void)startWithCallback:(ImageCallback)callback {
    imageCallback = callback;

    generator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    generator.appliesPreferredTrackTransform = YES;

    durationSeconds = CMTimeGetSeconds(self.asset.duration);
    secondsIn = 0;

    [self snapshotImage];
}

- (void)snapshotImage {

    CMTime time = CMTimeMake(secondsIn, 1);
    CGImageRef oneRef = [generator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    imageCallback(one);
    CGImageRelease(oneRef);

    secondsIn++;
    if (secondsIn < durationSeconds) {
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(snapshotImage)
                                       userInfo:nil
                                        repeats:NO];
    }
}

@end

