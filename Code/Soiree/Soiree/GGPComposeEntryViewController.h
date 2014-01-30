//
//  GGPComposeEntryViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPLogEntry.h"
#import "GGPVideoEntryViewController.h"
#import "GGPTextEntryViewController.h"
#import <Parse/Parse.h>

@interface GGPComposeEntryViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (strong, nonatomic) GGPLogEntry *entry;
@property (strong, nonatomic) PFObject *event;

@property (strong, nonatomic) GGPVideoEntryViewController *vidController;
@property (strong, nonatomic) GGPTextEntryViewController *txtController;


- (IBAction)pickImage:(id)sender;
- (IBAction)submitButton:(id)sender;


@end
