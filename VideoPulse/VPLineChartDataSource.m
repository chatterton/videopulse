//
//  VPLineChartDataSource.m
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPLineChartDataSource.h"

@implementation VPLineChartDataSource

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return 3;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    float val = 0;
    switch (horizontalIndex) {
        case 0:
            val = 0.3;
            break;
        case 1:
            val = 0.75;
            break;
        case 2:
            val = 0.2;
            break;
    }
    return val;
}



@end
