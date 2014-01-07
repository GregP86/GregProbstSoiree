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

-(void)Register;

@end
