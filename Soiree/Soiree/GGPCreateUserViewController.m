//
//  GGPCreateUserViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/6/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPCreateUserViewController.h"

@interface GGPCreateUserViewController ()

@end

@implementation GGPCreateUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createButton:(id)sender {
    [self Register];
}

-(void)Register{
    PFUser *user = [PFUser user];
    user.username = self.userNameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    
    if([self.passwordConfirmField.text isEqualToString:self.passwordField.text]){
    
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self performSegueWithIdentifier:@"backToFirst" sender:self];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                [self.errorLabel setText:errorString];
            }
        }];
    } else{
        [self.errorLabel setText:@"Passwords do not match."];
    }
}

-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
