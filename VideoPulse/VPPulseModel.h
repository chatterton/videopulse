//
//  VPPulseModel.h
//  VideoPulse
//
//  Created by Jack Chatterton on 3/28/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPPulseModel : NSObject

@property NSTimeInterval firstTime;
@property NSTimeInterval lastTime;

- (void)addSample:(float)val atTime:(NSTimeInterval)time;

- (NSArray *)render:(int)sampleCount;

@end
