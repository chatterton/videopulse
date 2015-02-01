//
//  VPImageFilter.m
//  VideoPulse
//
//  Created by Jack Chatterton on 2/1/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPImageFilter.h"
#import <UIKit/UIKit.h>

@implementation VPImageFilter

- (void)process:(UIImage *)image {
    NSLog(@"got one: %f %f", image.size.width, image.size.height);
    // Awesome, this puts out 1280 x 720 from the sample file
}

@end
