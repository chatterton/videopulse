//
//  VPCapture.h
//  VideoPulse
//
//  Created by Jack Chatterton on 1/31/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface VPCapture : AVCaptureVideoDataOutput <AVCaptureVideoDataOutputSampleBufferDelegate>

typedef void (^ImageCallback)(CGImageRef image);

@property CGImageRef lastCapturedImage;

- (void)startWithCallback:(ImageCallback)callback;

@end
