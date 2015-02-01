//
//  ViewController.m
//  VideoPulse
//
//  Created by Jack Chatterton on 1/31/15.
//  Copyright (c) 2015 Postreal Media. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction) playVideo:(id) sender {
    NSURL *MyURL = [[NSBundle mainBundle] URLForResource: @"video" withExtension:@"mov"];
    NSLog(@"Got one %@", MyURL);
}


@end
