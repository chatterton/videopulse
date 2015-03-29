//
//  VPLineChartDataSource.m
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPLineChartDataSource.h"

@interface VPLineChartDataSource () {
    NSMutableArray *sampleBuffer;
}
@end

@implementation VPLineChartDataSource

-(id)init {
    if ( self = [super init] ) {
        sampleBuffer = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSample:(float)val {
    [sampleBuffer insertObject:[NSNumber numberWithFloat:val] atIndex:0];
    if (sampleBuffer.count > sampleBufferSize) {
        [sampleBuffer removeLastObject];
    }
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return sampleBuffer.count;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [(NSNumber *)[sampleBuffer objectAtIndex:horizontalIndex] floatValue];
}

@end
