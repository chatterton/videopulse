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
#import "VPImageFilter.h"
#import "VPVideoDivider.h"

@interface ViewController () {
    AVPlayer *player;
    IBOutlet VPPlayerLayer *playerView;
    IBOutlet UIImageView *output;
    VPImageFilter *filter;
    VPVideoDivider *divider;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    filter = [[VPImageFilter alloc] init];

    NSURL *url = [[NSBundle mainBundle] URLForResource: @"video" withExtension:@"mov"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    playerView.player = player;
    divider = [[VPVideoDivider alloc] init];
    divider.asset = asset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)playVideo:(id) sender {
    [player play];
    [divider startWithCallback:^(UIImage *image) {
        [self processImageCallback:image];
    }];
}

- (void)processImageCallback:(UIImage *) image {
    [filter process:image];
    [output setImage:image];
}



@end
