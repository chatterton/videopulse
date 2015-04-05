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
    // create array of size n
    NSMutableArray *output = [NSMutableArray array];
    for (int i = 0; i < sampleCount; i++) {
        [output  insertObject:[NSNumber numberWithFloat:0.5] atIndex:0];
    }

    // sanity check
    if ([timeBuffer count] < 2) {
        return output;
    }

    // set up first window
    long bufferIndex = ([timeBuffer count] - 1); // last to first
    double firstTime = [(NSNumber *)[timeBuffer objectAtIndex:bufferIndex] doubleValue];
    double lastTime = [(NSNumber *)[timeBuffer objectAtIndex:0] doubleValue];
    double tick = (lastTime - firstTime) / sampleCount;
    float valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:bufferIndex] floatValue];
    float valueNext = [(NSNumber *)[sampleBuffer objectAtIndex:(bufferIndex - 1)] floatValue];
    double timeNow = firstTime;
    double timeNext = [(NSNumber *)[timeBuffer objectAtIndex:(bufferIndex - 1)] doubleValue];

    // loop through all windows and tween values
    int i = sampleCount - 1;
    int count = 0;
    while (i > 0) {
        if (timeNow >= timeNext) {
            // fill in interim values
            for (int j = 0; j < count; j++) {
                float stepValue = valueNow + ((valueNext - valueNow) * ((float)j / count));
                [output replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:stepValue]];
                i--;
            }
            count = -1;
            bufferIndex--;

            // set up next two samples
            if (bufferIndex > 0) {
                // another sample in buffer, queue it up
                timeNow = timeNext;
                timeNext = [(NSNumber *)[timeBuffer objectAtIndex:(bufferIndex - 1)] doubleValue];
                valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:bufferIndex] floatValue];
                valueNext = [(NSNumber *)[sampleBuffer objectAtIndex:(bufferIndex - 1)] floatValue];
            } else {
                // no more buffer: finish
                if (i > 0) {
                    timeNow = timeNext;
                    valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:0] floatValue];
                    valueNext = valueNow;
                    count = i+1;
                }
            }
        } else {
            timeNow += tick;
            if (count < sampleCount) {
                count++;
            }
        }
    }

    return output;
}

@end
