//
//  GGPLogInViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/7/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLogInViewController.h"

@interface GGPLogInViewController ()

@end

@implementation GGPLogInViewController

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

- (IBAction)submitButton:(id)sender {
    [self logIn];
}

-(void)logIn{
    [PFUser logInWithUsernameInBackground:self.userNameField.text
                                 password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if(user){
                                            self.userMessage = @"You are now logged into Soirée!";
                                            [self performSegueWithIdentifier:@"backToFirst" sender:self];
                                        }else{
                                           NSString *errorString = [error userInfo][@"error"];
                                            [self.errorLabel setText:errorString];
                                        }
                                    }];
}

-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"backToFirst"]) {
        GGPViewController *destination = [segue destinationViewController];
        destination.uesrMessageLabel.text = self.userMessage;
    }
}

@end
