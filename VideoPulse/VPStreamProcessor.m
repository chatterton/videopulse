//
//  VPImageFilter.m
//  VideoPulse
//
//  Created by Jack Chatterton on 2/1/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPStreamProcessor.h"

@implementation VPStreamProcessor {
    CGImageRef lastImage;
}

- (CGImageRef)getFaceFromFrame:(CIImage *)ciImage {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                            context:nil
                                            options:nil];
    NSArray *faceArray = [detector featuresInImage:ciImage options:nil];

    if (faceArray.count > 0) {
        CIFeature *face = faceArray[0];
        CGFloat xCenter = face.bounds.origin.x + face.bounds.size.width/2.0;
        CGFloat yCenter = face.bounds.origin.y + face.bounds.size.height/2.0;
        CIVector *center = [CIVector vectorWithX:xCenter Y:yCenter];
        CGFloat radius = face.bounds.size.width/2.8;
        CIColor *alphaOne = [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        CIColor *alphaZero = [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

        NSLog(@"face at %f, %f with radius %f", xCenter, yCenter, radius);

        CIFilter* filter = [CIFilter filterWithName:@"CIRadialGradient"];
        [filter setDefaults];
        [filter setValue:center forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius0"];
        [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius1"];
        [filter setValue:alphaOne forKey:@"inputColor0"];
        [filter setValue:alphaZero forKey:@"inputColor1"];

        CIFilter *maskFilter = [CIFilter filterWithName:@"CISourceInCompositing"
                                          keysAndValues:
                                @"inputImage", ciImage,
                                @"inputBackgroundImage", [filter outputImage], nil];

        return [[CIContext contextWithOptions:nil] createCGImage:[maskFilter outputImage]
                               fromRect:[ciImage extent]];
    } else {
        NSLog(@"no face detected");
    }
    return nil;
}

- (void)process:(CGImageRef)image {
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSLog(@"got one: %zu %zu at time %f", CGImageGetWidth(image), CGImageGetHeight(image), timeInMiliseconds);

    CGImageRef processed = [self getFaceFromFrame:[CIImage imageWithCGImage:image]];

    if (processed) {
        CGImageRelease(lastImage);
        lastImage = processed;
    }

}

- (CGImageRef)lastProcessedImage {
    return lastImage;
}

@end
