//
//  VPLineChartDataSource.m
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPLineChartDataSource.h"
#import "VPPulseModel.h"

const int LINE_CHART_POINTS = 1000;

@interface VPLineChartDataSource () {
    VPPulseModel *model;
    NSArray *lastArray;
}
@end

@implementation VPLineChartDataSource

-(id)initWithModel:(VPPulseModel *)m {
    if ( self = [super init] ) {
        model = m;
    }
    return self;
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    lastArray = [model render:LINE_CHART_POINTS];
    return [lastArray count];
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [(NSNumber *)[lastArray objectAtIndex:horizontalIndex] floatValue];
}

@end
