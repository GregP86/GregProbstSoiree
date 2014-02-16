//
//  GGPSlideShowOptionsViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/14/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPSlideShowOptionsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *selectedSongLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

- (IBAction)slider:(id)sender;
- (IBAction)fadeTrasitionSwitch:(id)sender;
- (IBAction)includePhotoSwitch:(id)sender;
- (IBAction)includeText:(id)sender;
- (IBAction)inludeVideoSwitch:(id)sender;

@end
