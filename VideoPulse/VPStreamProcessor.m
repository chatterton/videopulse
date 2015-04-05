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

const float FACE_CROP_FACTOR = 0.3;

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

- (CIImage *)getFaceFromFrame:(CIImage *)frame {
    NSArray *faceArray = [detector featuresInImage:frame options:nil];
    CIImage *image = nil;

    if (faceArray.count > 0) {
        CIFeature *face = faceArray[0];
        float croppedWidth = face.bounds.size.width * FACE_CROP_FACTOR;
        float croppedHeight = face.bounds.size.height * FACE_CROP_FACTOR;
        float croppedX = face.bounds.origin.x + ((face.bounds.size.width - croppedWidth) / 2.0);
        float croppedY = face.bounds.origin.y + ((face.bounds.size.height - croppedHeight) / 2.0);
        image = [frame imageByCroppingToRect:CGRectMake(croppedX, croppedY, croppedWidth, croppedHeight)];
        //NSLog(@"face of size %i, %i located at %i, %i", (int)croppedWidth, (int)croppedHeight, (int)croppedX, (int)croppedY);
    } else {
        //NSLog(@"no face detected");
    }

    return image;
}

- (void)updateOutputsFromFace:(CGImageRef)faceImage {
    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(faceImage));
    UInt8 *buf = (UInt8 *) CFDataGetBytePtr(rawData);
    long length = CFDataGetLength(rawData);
    float rTotal = 0;
    float gTotal = 0;
    float bTotal = 0;
    int foundPixels = 0;
    for (int i = 0; i < length; i += 4) {
        int r = buf[i];
        int g = buf[i+1];
        int b = buf[i+2];
        int a = buf[i+3];
        if (a == 255) {
            rTotal += r;
            gTotal += g;
            bTotal += b;
            foundPixels++;
        }
    }
    float rAvg = rTotal / foundPixels;
    float gAvg = gTotal / foundPixels;
    float bAvg = bTotal / foundPixels;
    self.lastAverageColor = [UIColor colorWithRed:(rAvg / 255.0)
                                            green:(gAvg / 255.0)
                                             blue:(bAvg / 255.0)
                                            alpha:1.0];
    self.lastRedPercent = rAvg / (rAvg + gAvg + bAvg);
}

- (void)process:(CGImageRef)image {
    CIImage *frame = [CIImage imageWithCGImage:image];
    CIImage *processed = [self getFaceFromFrame:frame];
    if (processed) {
        CGImageRef ref = [ciContext createCGImage:processed fromRect:[frame extent]];
        CGImageRelease(self.lastProcessedImage);
        self.lastProcessedImage = ref;
        [self updateOutputsFromFace:ref];
    }
}

@end
