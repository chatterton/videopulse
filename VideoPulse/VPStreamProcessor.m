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
}

const float FACE_CROP_FACTOR = 0.5;

-(id)init {
    if ( self = [super init] ) {
        EAGLContext *eagl = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        ciContext = [CIContext contextWithEAGLContext:eagl];
        [EAGLContext setCurrentContext:eagl]; // todo: this may not be doing anything useful
        detector =[CIDetector detectorOfType:CIDetectorTypeFace
                                     context:ciContext
                                     options:nil];
    }
    return self;
}

- (CGImageRef)getFaceFromFrame:(CIImage *)frame {
    NSArray *faceArray = [detector featuresInImage:frame options:nil];
    CGImageRef ref = nil;

    if (faceArray.count > 0) {
        CIFeature *face = faceArray[0];
        float croppedWidth = face.bounds.size.width * FACE_CROP_FACTOR;
        float croppedHeight = face.bounds.size.height * FACE_CROP_FACTOR;
        float croppedX = face.bounds.origin.x + ((face.bounds.size.width - croppedWidth) / 2.0);
        float croppedY = face.bounds.origin.y + ((face.bounds.size.height - croppedHeight) / 2.0);
        CIImage *faceImage = [frame imageByCroppingToRect:CGRectMake(croppedX, croppedY, croppedWidth, croppedHeight)];
        NSLog(@"face of size %i, %i located at %i, %i", (int)croppedWidth, (int)croppedHeight, (int)croppedX, (int)croppedY);
        ref = [ciContext createCGImage:faceImage fromRect:[frame extent]];
    } else {
        NSLog(@"no face detected");
    }

    return ref;
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
