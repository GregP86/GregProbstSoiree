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
#import "GGPStats.h"
#import "GGPWordCloudRetriever.h"
#import "GGPTextFilter.h"

@interface GGPSlideshowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *logs;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) GGPSlideshowOptions *options;
@property (strong, nonatomic) MPMusicPlayerController *player;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWomen;
@property (weak, nonatomic) IBOutlet UILabel *totalMen;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *underEighteen;
@property (weak, nonatomic) IBOutlet UILabel *toTwentyfive;
@property (weak, nonatomic) IBOutlet UILabel *toThirtyFive;
@property (weak, nonatomic) IBOutlet UILabel *toFourtyfive;
@property (weak, nonatomic) IBOutlet UILabel *toFiftyfive;
@property (weak, nonatomic) IBOutlet UILabel *aboveFiftyFive;
@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PFObject *event;


@end
