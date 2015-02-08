//
//  VPImageFilter.h
//  VideoPulse
//
//  Created by Jack Chatterton on 2/1/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@interface VPStreamProcessor : NSObject

- (void)process:(CGImageRef)image;

@end
