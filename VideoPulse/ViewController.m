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
    VPStreamProcessor *videoProcessor;
    VPStreamProcessor *cameraProcessor;
    VPVideoDivider *divider;
    VPCapture *capture;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    videoProcessor = [[VPStreamProcessor alloc] init];
    cameraProcessor = [[VPStreamProcessor alloc] init];

    NSURL *url = [[NSBundle mainBundle] URLForResource: @"video" withExtension:@"mov"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    playerView.player = player;

    divider = [[VPVideoDivider alloc] init];
    divider.asset = asset;
    [divider setDesiredFPS:6.0];

    capture = [[VPCapture alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)playVideo:(id) sender {
    [player play];
    [divider startWithCallback:^(CGImageRef image) {
        [self processVideoFrameCallback:image];
    }];
}

- (void)processVideoFrameCallback:(CGImageRef) image {
    [videoProcessor process:image];
    [videoFrameOutput setImage:[UIImage imageWithCGImage:[videoProcessor lastProcessedImage]]];
}

-(IBAction)startCameraCapture:(id) sender {
    [capture startWithCallback:^(CGImageRef image) {
        [self processCameraFrameCallback:image];
    }];
}

- (void)processCameraFrameCallback:(CGImageRef) image {
    [cameraFrame setImage:[UIImage imageWithCGImage:[capture lastCapturedImage]]];
    [cameraProcessor process:[capture lastCapturedImage]];
    [processedCameraFrameOutput setImage:[UIImage imageWithCGImage:[cameraProcessor lastProcessedImage]]];
}

@end
