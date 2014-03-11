//
//  GGPSlideShowOptionsViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/14/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPSlideshowOptions.h"
#import "GGPEventLogViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface GGPSlideShowOptionsViewController : UITableViewController<MPMediaPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedSongLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UISlider *frameSlider;
@property (strong, nonatomic) GGPSlideshowOptions *options;
@property (strong, nonatomic) MPMediaPickerController *picker;
@property (weak, nonatomic) IBOutlet UISwitch *transitionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *photosSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *textSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *statsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cloudSwitch;

- (IBAction)slider:(id)sender;
- (IBAction)fadeTrasitionSwitch:(id)sender;
- (IBAction)includePhotoSwitch:(id)sender;
- (IBAction)includeText:(id)sender;
- (IBAction)inludeVideoSwitch:(id)sender;
- (IBAction)includeStatsSwitch:(id)sender;
- (IBAction)includeWordCloudSwitch:(id)sender;

@end
