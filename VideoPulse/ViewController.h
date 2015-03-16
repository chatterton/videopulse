//
//  ViewController.h
//  VideoPulse
//
//  Created by Jack Chatterton on 1/31/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPPlayerLayer;

@interface ViewController : UIViewController {
    IBOutlet VPPlayerLayer *playerView;
    IBOutlet UIImageView *videoFrameOutput;
    IBOutlet UIImageView *cameraFrame;
    IBOutlet UIImageView *processedCameraFrameOutput;
    IBOutlet UIView *averageColorView;
    IBOutlet UITextView *percentages;
}


@end

