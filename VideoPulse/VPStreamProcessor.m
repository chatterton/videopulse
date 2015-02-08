//
//  VPImageFilter.m
//  VideoPulse
//
//  Created by Jack Chatterton on 2/1/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPStreamProcessor.h"

@implementation VPStreamProcessor

- (void)process:(CGImageRef)image {
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];

    NSLog(@"got one: %zu %zu at time %f", CGImageGetWidth(image), CGImageGetHeight(image), timeInMiliseconds);
}

@end
