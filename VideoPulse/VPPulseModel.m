//
//  VPPulseModel.m
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPPulseModel.h"

NSInteger const SAMPLE_BUFFER_SIZE = 50; // 50 = about 1.24 s

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
    if (sampleBuffer.count > SAMPLE_BUFFER_SIZE) {
        [sampleBuffer removeLastObject];
        [timeBuffer removeLastObject];
    }
}

- (NSArray *)render:(NSInteger)sampleCount {
    // sanity check
    if ([timeBuffer count] < 2) {
        return @[];
    }

    long bufferIndex = ([timeBuffer count] - 1); // last to first
    double firstTime = [(NSNumber *)[timeBuffer objectAtIndex:bufferIndex] doubleValue];
    double lastTime = [(NSNumber *)[timeBuffer objectAtIndex:0] doubleValue];
    double tick = (lastTime - firstTime) / sampleCount;
    float value = [(NSNumber *)[sampleBuffer objectAtIndex:bufferIndex] floatValue];
    double time = firstTime;

    NSMutableArray *output = [NSMutableArray arrayWithCapacity:sampleCount];
    for (int i = 0; i < sampleCount; i++) {
        [output insertObject:[NSNumber numberWithFloat:value] atIndex:i];
        time += tick;
        while ((bufferIndex > 0) && (time > [(NSNumber *)[timeBuffer objectAtIndex:bufferIndex] doubleValue])) {
            bufferIndex--;
        }
        value = [(NSNumber *)[sampleBuffer objectAtIndex:([sampleBuffer count] - 1 - bufferIndex)] floatValue];
    }

    return output;
}

@end
