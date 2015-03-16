//
//  ViewController.m
//  VideoPulse
//
//  Created by Jack Chatterton on 1/31/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "ViewController.h"
#import "VPPlayerLayer.h"
#import "VPStreamProcessor.h"
#import "VPVideoDivider.h"
#import "VPCapture.h"

@interface ViewController () {
    AVPlayer *player;
    VPStreamProcessor *processor;
    VPVideoDivider *divider;
    VPCapture *capture;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    processor = [[VPStreamProcessor alloc] init];

    NSURL *url = [[NSBundle mainBundle] URLForResource: @"video" withExtension:@"mov"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    playerView.player = player;

    divider = [[VPVideoDivider alloc] init];
    divider.asset = asset;
    [divider setDesiredFPS:6.0];

    capture = [[VPCapture alloc] init];
}

- (void)process:(CGImageRef)image toOutput:(UIImageView *)imageView {
    [processor process:image];
    [imageView setImage:[UIImage imageWithCGImage:[processor lastProcessedImage]]];
    [averageColorView setBackgroundColor:[processor lastAverageColor]];
}

-(IBAction)playVideo:(id) sender {
    [player play];
    [divider startWithCallback:^(CGImageRef image) {
        [self processVideoFrameCallback:image];
    }];
}

- (void)processVideoFrameCallback:(CGImageRef) image {
    [self process:image toOutput:videoFrameOutput];
}

-(IBAction)startCameraCapture:(id) sender {
    [capture startWithCallback:^(CGImageRef image) {
        [self processCameraFrameCallback:image];
    }];
}

- (void)processCameraFrameCallback:(CGImageRef) image {
    [cameraFrame setImage:[UIImage imageWithCGImage:[capture lastCapturedImage]]];
    [self process:[capture lastCapturedImage] toOutput:processedCameraFrameOutput];
}

@end
