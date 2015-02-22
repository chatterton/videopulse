//
//  VPImageFilter.m
//  VideoPulse
//
//  Created by Jack Chatterton on 2/1/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "VPStreamProcessor.h"

@implementation VPStreamProcessor {
    CIDetector *detector;
    CIContext *ciContext;
    CIFilter *radialFilter;
    CIFilter *maskFilter;
}

-(id)init {
    if ( self = [super init] ) {
        EAGLContext *eagl = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        ciContext = [CIContext contextWithEAGLContext:eagl];
        [EAGLContext setCurrentContext:eagl]; // todo: this may not be doing anything useful
        detector =[CIDetector detectorOfType:CIDetectorTypeFace
                                     context:ciContext
                                     options:nil];

        radialFilter = [CIFilter filterWithName:@"CIRadialGradient"];
        [radialFilter setDefaults];
        CIColor *alphaOne = [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        CIColor *alphaZero = [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        [radialFilter setValue:alphaOne forKey:@"inputColor0"];
        [radialFilter setValue:alphaZero forKey:@"inputColor1"];

        maskFilter = [CIFilter filterWithName:@"CISourceInCompositing"];
    }
    return self;
}

- (CGImageRef)getFaceFromFrame:(CIImage *)ciImage {
    NSArray *faceArray = [detector featuresInImage:ciImage options:nil];

    if (faceArray.count > 0) {
        CIFeature *face = faceArray[0];
        CGFloat xCenter = face.bounds.origin.x + face.bounds.size.width/2.0;
        CGFloat yCenter = face.bounds.origin.y + face.bounds.size.height/2.0;
        CIVector *center = [CIVector vectorWithX:xCenter Y:yCenter];
        CGFloat radius = face.bounds.size.width/2.8;

        NSLog(@"face at %f, %f with radius %f", xCenter, yCenter, radius);

        [radialFilter setValue:center forKey:@"inputCenter"];
        [radialFilter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius0"];
        [radialFilter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius1"];

        [maskFilter setValue:ciImage forKey:@"inputImage"];
        [maskFilter setValue:[radialFilter outputImage] forKey:@"inputBackgroundImage"];

        return [ciContext createCGImage:[maskFilter outputImage]
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
        CGImageRelease(self.lastProcessedImage);
        self.lastProcessedImage = processed;
    }

}

@end
