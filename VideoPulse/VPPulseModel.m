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

- (NSArray *)render:(int)sampleCount {
    NSMutableArray *output = [NSMutableArray array];
    for (int i = 0; i < sampleCount; i++) {
        [output  insertObject:[NSNumber numberWithFloat:0.5] atIndex:0];
    }

    // sanity check
    if ([timeBuffer count] < 2) {
        return output;
    }

    long bufferIndex = ([timeBuffer count] - 1); // last to first
    double firstTime = [(NSNumber *)[timeBuffer objectAtIndex:bufferIndex] doubleValue];
    double lastTime = [(NSNumber *)[timeBuffer objectAtIndex:0] doubleValue];
    double tick = (lastTime - firstTime) / sampleCount;
    float valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:bufferIndex] floatValue];
    float valueNext = [(NSNumber *)[sampleBuffer objectAtIndex:(bufferIndex - 1)] floatValue];
    double timeNow = firstTime;
    double timeNext = [(NSNumber *)[timeBuffer objectAtIndex:(bufferIndex - 1)] doubleValue];

    //float output[sampleCount];

    int i = sampleCount - 1;
    while (i >= 0) {
        [output replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:valueNow]];
        timeNow += tick;
        if ((bufferIndex > 0) && (timeNow > [(NSNumber *)[timeBuffer objectAtIndex:bufferIndex] doubleValue])) {
            valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:([sampleBuffer count] - 1 - bufferIndex)] floatValue];
            bufferIndex--;
        }
        i--;
    }

    return output;
}

@end
