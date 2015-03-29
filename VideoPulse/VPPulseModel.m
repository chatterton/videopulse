//
//  VPPulseModel.m
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPPulseModel.h"

NSInteger const bufferSize = 100;

@interface VPPulseModel () {
    NSMutableArray *sampleBuffer;
    NSMutableArray *timeBuffer;
}
@end

@implementation VPPulseModel

-(id)init {
    if ( self = [super init] ) {
        sampleBuffer = [[NSMutableArray alloc] init];
        timeBuffer = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSample:(float)val atTime:(NSTimeInterval)time {
    [sampleBuffer insertObject:[NSNumber numberWithFloat:val] atIndex:0];
    [timeBuffer insertObject:[NSNumber numberWithDouble:time] atIndex:0];
    if (sampleBuffer.count > bufferSize) {
        [sampleBuffer removeLastObject];
        [timeBuffer removeLastObject];
    }
}

- (NSArray *)render:(NSInteger)sampleCount {
    return sampleBuffer;
}

@end
