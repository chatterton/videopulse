//
//  VPLineChartDataSource.h
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBLineChartView.h"

NSInteger const sampleBufferSize = 100;

@interface VPLineChartDataSource : NSObject <JBLineChartViewDataSource, JBLineChartViewDelegate>

- (void)addSample:(float)val;

@end
