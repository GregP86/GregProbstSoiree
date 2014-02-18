//
//  GGPSlideshowViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPLogEntry.h"
#import "GGPLabelConverter.h"
#import "GGPSlideshowOptions.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GGPSlideshowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *logs;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) GGPSlideshowOptions *options;
@property (strong, nonatomic) MPMusicPlayerController *player;

@end
