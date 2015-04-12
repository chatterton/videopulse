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
#import "VPLineChartDataSource.h"
#import "VPPulseModel.h"

@interface ViewController () {
    AVPlayer *player;
    VPStreamProcessor *processor;
    VPVideoDivider *divider;
    VPCapture *capture;
    VPLineChartDataSource *lineChartSource;
    VPPulseModel *model;
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

    percentages.text = @"";

    model = [[VPPulseModel alloc] init];
    lineChartSource = [[VPLineChartDataSource alloc] initWithModel:model];
    lineChartView.dataSource = lineChartSource;
    lineChartView.delegate = lineChartSource;
}

- (void)process:(CGImageRef)image toOutput:(UIImageView *)imageView {
    [processor process:image];
    [imageView setImage:[UIImage imageWithCGImage:[processor lastProcessedImage]]];
    [averageColorView setBackgroundColor:[processor lastAverageColor]];

    if ([processor lastRedPercent] > 0.0) {
        NSString *new = [NSString stringWithFormat:@"%f \n %@", [processor lastRedPercent], percentages.text];
        [percentages setText:new];

        [model addSample:[processor lastRedPercent] atTime:[[NSDate date] timeIntervalSince1970]];
        [lineChartView reloadData];
        [self updateCounterLog];
    }
}

- (IBAction)playVideo:(id) sender {
    [player play];
    [divider startWithCallback:^(CGImageRef image) {
        [self processVideoFrameCallback:image];
    }];
}

- (void)processVideoFrameCallback:(CGImageRef) image {
    [self process:image toOutput:videoFrameOutput];
}

- (void)updateCounterLog {
    NSTimeInterval seconds = 0;
    if (model.firstTime && model.lastTime) {
        seconds = model.lastTime - model.firstTime;
    }
    NSInteger peakCount = model.peakCount;
    float bpm;
    if (peakCount && seconds != 0) {
        bpm = (((float)peakCount) / seconds) * 60.0;
    } else {
        bpm = 0;
    }
    counterLog.text = [NSString stringWithFormat:@"Buffer length: %.1f s \nPeaks: %i \nBPM: %f", seconds, (int)model.peakCount, bpm];
}

- (IBAction)startCameraCapture:(id) sender {
    [capture startWithCallback:^(CGImageRef image) {
        [self processCameraFrameCallback:image];
    }];
}

- (void)processCameraFrameCallback:(CGImageRef) image {
    [cameraFrame setImage:[UIImage imageWithCGImage:[capture lastCapturedImage]]];
    [self process:[capture lastCapturedImage] toOutput:processedCameraFrameOutput];
}

- (IBAction)reset:(id) sender {
    [divider stop];
    [capture stop];
    [player pause];

    // FIXME: this is the wrong way to do this. but half second delay should allow the last frame
    // to get processed and then blank it.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cameraFrame setImage:nil];
        [processedCameraFrameOutput setImage:nil];
        [videoFrameOutput setImage:nil];
        percentages.text = @"";
    });
}

@end
