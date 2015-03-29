//
//  VPLineChartDataSource.h
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBLineChartView.h"

@class VPPulseModel;

@interface VPLineChartDataSource : NSObject <JBLineChartViewDataSource, JBLineChartViewDelegate>

-(id)initWithModel:(VPPulseModel *)m;

@end
