//
//  VPPlayerLayer.m
//  VideoPulse
//
//  Created by Jack Chatterton on 1/31/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VPPlayerLayer : UIView

@property (nonatomic) AVPlayer *player;

@end

@implementation VPPlayerLayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
