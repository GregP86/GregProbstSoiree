//
//  GGPTextEntryViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/28/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGPLogEntry.h"
#import <QuartzCore/QuartzCore.h>
#import "GGPEventLogViewController.h"

@interface GGPTextEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) PFObject *event;
@property (strong, nonatomic) GGPLogEntry *entry;
@property (weak, nonatomic) IBOutlet UIButton *submit;

- (IBAction)submitButton:(id)sender;


@end
