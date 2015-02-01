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
    AVAsset *asset;
    IBOutlet UIImageView *output;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"video" withExtension:@"mov"];
    asset = [AVAsset assetWithURL:url];
    player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    player = [AVPlayer playerWithURL:url];
    playerView.player = player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)playVideo:(id) sender {
    [player play];
    
    // this via http://stackoverflow.com/questions/19105721/thumbnailimageattime-now-deprecated-whats-the-alternative
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate1.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(2, 1);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];

    [output setImage:one];
}




@end
