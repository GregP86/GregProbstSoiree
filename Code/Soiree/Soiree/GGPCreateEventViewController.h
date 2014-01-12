//
//  GGPCreateEventViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/9/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPCreateEventViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *locationNamField;
@property (weak, nonatomic) IBOutlet UILabel *gpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isPrivate;
@property (weak, nonatomic) IBOutlet UISwitch *isLocationsOn;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;

- (IBAction)privateSwitch:(id)sender;
- (IBAction)locationSwitch:(id)sender;
- (IBAction)createEventButton:(id)sender;

@end
