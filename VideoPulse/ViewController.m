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

@interface ViewController () {
    AVPlayer *player;
    IBOutlet VPPlayerLayer *playerView;
    IBOutlet UIImageView *output;
    VPStreamProcessor *processor;
    VPVideoDivider *divider;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)playVideo:(id) sender {
    [player play];
    [divider startWithCallback:^(CGImageRef image) {
        [self processImageCallback:image];
    }];
}

- (void)processImageCallback:(CGImageRef) image {
    [processor process:image];
    [output setImage:[UIImage imageWithCGImage:[processor lastProcessedImage]]];
}



@end
