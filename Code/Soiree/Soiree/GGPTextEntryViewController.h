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

@interface GGPTextEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) PFObject *event;
@property (strong, nonatomic) GGPLogEntry *entry;

- (IBAction)submitButton:(id)sender;


@end
