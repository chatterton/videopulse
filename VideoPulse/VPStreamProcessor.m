//
//  VPImageFilter.m
//  VideoPulse
//
//  Created by Jack Chatterton on 2/1/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPStreamProcessor.h"

@implementation VPStreamProcessor {
    CGImageRef lastImage;
}

- (void)process:(CGImageRef)image {
    lastImage = image;

    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSLog(@"got one: %zu %zu at time %f", CGImageGetWidth(image), CGImageGetHeight(image), timeInMiliseconds);
}

- (CGImageRef)lastProcessedImage {
    return lastImage;
}

@end
