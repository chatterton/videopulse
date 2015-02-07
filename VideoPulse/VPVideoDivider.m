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

@implementation VPVideoDivider

- (void)startWithCallback:(ImageCallback)callback {

    // this via stackoverflow.com/questions/19105721/thumbnailimageattime-now-deprecated-whats-the-alternative
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    generate1.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(2, 1);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    callback(one);

}

@end
