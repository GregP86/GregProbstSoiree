//
//  GGPCreateEventViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/9/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <Parse/Parse.h>
#import "GGPLocation.h"
#import "GGPEvent.h"
#import "GGPHash.h"

@interface GGPCreateEventViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@property (weak, nonatomic) IBOutlet UITextField *locationNamField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property CLLocationCoordinate2D coords;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *isPrivate;
@property (weak, nonatomic) IBOutlet UISwitch *isLocationsOn;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (weak, nonatomic) IBOutlet UISwitch *locSwitch;



- (IBAction)privateSwitch:(id)sender;
- (IBAction)locationSwitch:(id)sender;
- (IBAction)createEventButton:(id)sender;

@end
