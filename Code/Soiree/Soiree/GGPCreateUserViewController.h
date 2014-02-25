//
//  GGPCreateUserViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/6/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPViewController.h"

@interface GGPCreateUserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) NSString *userMessage;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UISwitch *gender;

-(void)Register;
-(IBAction)textFieldReturn:(id)sender;
- (IBAction)genderSwitch:(id)sender;

@end
