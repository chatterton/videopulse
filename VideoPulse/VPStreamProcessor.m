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
//    CIFilter *histoFilter;
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

        /*
        histoFilter = [CIFilter filterWithName:@"CIAreaHistogram"];
        [histoFilter setValue:@1 forKey:@"inputCount"];
        [histoFilter setValue:@1.0 forKey:@"inputScale"];
         */
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
        NSLog(@"face of size %i, %i located at %i, %i", (int)croppedWidth, (int)croppedHeight, (int)croppedX, (int)croppedY);
    } else {
        NSLog(@"no face detected");
    }

    return image;
}

- (CIImage *)getAverageFromFace:(CIImage *)faceImage {

    /*
    [histoFilter setValue:faceImage forKey: @"inputImage"];
    return [histoFilter valueForKey: @"outputImage"];
     */
    return nil;
}

- (void)process:(CGImageRef)image {
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSLog(@"got one: %zu %zu at time %f", CGImageGetWidth(image), CGImageGetHeight(image), timeInMiliseconds);

    CIImage *frame = [CIImage imageWithCGImage:image];
    CIImage *processed = [self getFaceFromFrame:frame];

    if (processed) {
        CGImageRef ref = [ciContext createCGImage:processed fromRect:[frame extent]];
        CGImageRelease(self.lastProcessedImage);
        self.lastProcessedImage = ref;

        /*
    //    self.lastProcessedAverage = [UIImage imageWithCIImage:[self getAverageFromFace:processed]];
        CIImage *ciHisto = [self getAverageFromFace:processed];
        CGImageRef cgHisto = [ciContext createCGImage:ciHisto fromRect:ciHisto.extent];

        CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(cgHisto));
        UInt8 * buf = (UInt8 *) CFDataGetBytePtr(rawData);
        long length = CFDataGetLength(rawData);
        for (int i = 0; i < length; i += 4) {
            float r = buf[i];
            float g = buf[i+1];
            float b = buf[i+2];
            NSLog(@"Got one %f %f %f", r, g, b);
        }

         */
    }

}

@end
