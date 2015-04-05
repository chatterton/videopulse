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

    long bufferIndex = ([timeBuffer count] - 1); // last to first
    double firstTime = [(NSNumber *)[timeBuffer objectAtIndex:bufferIndex] doubleValue];
    double lastTime = [(NSNumber *)[timeBuffer objectAtIndex:0] doubleValue];
    double tick = (lastTime - firstTime) / sampleCount;
    float valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:bufferIndex] floatValue];
    float valueNext = [(NSNumber *)[sampleBuffer objectAtIndex:(bufferIndex - 1)] floatValue];
    double timeNow = firstTime;
    double timeNext = [(NSNumber *)[timeBuffer objectAtIndex:(bufferIndex - 1)] doubleValue];

    int i = sampleCount - 1;
    int count = 0;
    float done = false;
    while (i > 0) {
        if (timeNow >= timeNext) {
            for (int j = 0; j < count; j++) {
                float stepValue = valueNow + ((valueNext - valueNow) * ((float)j / count));
                NSLog(@"putting val %f at index %i", stepValue, i);
                [output replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:stepValue]];
                i--;
            }
            count = -1;
            bufferIndex--;

            if (bufferIndex > 0) {
                // Another sample in buffer
                timeNow = timeNext;
                timeNext = [(NSNumber *)[timeBuffer objectAtIndex:(bufferIndex - 1)] doubleValue];
                valueNow = [(NSNumber *)[sampleBuffer objectAtIndex:bufferIndex] floatValue];
                valueNext = [(NSNumber *)[sampleBuffer objectAtIndex:(bufferIndex - 1)] floatValue];
            } else {
                // No more buffer: finish
                if (i > 0) {
                    NSLog(@"finish him! count = %i index = %i", count, i);
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
        NSLog(@"loop end, count = %i", count);
    }

    NSLog(@"returning output");

    return output;
}

@end
