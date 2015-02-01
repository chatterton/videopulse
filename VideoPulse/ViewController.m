//
//  ViewController.m
//  VideoPulse
//
//  Created by Jack Chatterton on 1/31/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "ViewController.h"
#import "VPPlayerLayer.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController () {
    AVPlayer *player;
    IBOutlet VPPlayerLayer *playerView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"video" withExtension:@"mov"];
    player = [AVPlayer playerWithURL:url];
    playerView.player = player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)playVideo:(id) sender {
    [player play];
}


@end
