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

- (IBAction)slider:(id)sender;
- (IBAction)fadeTrasitionSwitch:(id)sender;
- (IBAction)includePhotoSwitch:(id)sender;
- (IBAction)includeText:(id)sender;
- (IBAction)inludeVideoSwitch:(id)sender;

@end
