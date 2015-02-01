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
    NSLog(@"got one: %d %d", image.size.width, image.size.height);
}

@end
