//
//  GGPEventOptionsViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GGPEventOptionsViewController : UITableViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *contentSwitch;
@property (weak, nonatomic) IBOutlet PFObject *event;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

- (IBAction)pressContentSwitch:(id)sender;
- (IBAction)deleteButton:(id)sender;

@end
