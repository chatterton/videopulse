//
//  VPVideoDivider.h
//  VideoPulse
//
//  Created by Jack Chatterton on 2/7/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

@class AVAsset, UIImage;

#import <Foundation/Foundation.h>

@interface VPVideoDivider : NSObject

@property AVAsset *asset;

typedef void (^ImageCallback)(CGImageRef image);

- (void)startWithCallback:(ImageCallback)callback;
- (void)setDesiredFPS:(float)desiredFPS;
- (void)stop;

@end

