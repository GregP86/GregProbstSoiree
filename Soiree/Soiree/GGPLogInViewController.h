//
//  GGPLogInViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/7/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGPViewController.h"

@interface GGPLogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) NSString *userMessage;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)submitButton:(id)sender;


@end
