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
    user[@"Events"] = [[NSMutableArray alloc] init];
    
    if([self.passwordConfirmField.text isEqualToString:self.passwordField.text]){
        [self signUpUser:user];
    } else{
        [self.errorLabel setText:@"Passwords do not match."];
    }
}

-(void)signUpUser:(PFUser *)user{
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.userMessage = @"You are now registered with Soirée";
            [self performSegueWithIdentifier:@"ToFirst" sender:self];
        } else {
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
    if ([[segue identifier] isEqualToString:@"ToFirst"]) {
        GGPViewController *destination = [segue destinationViewController];
        destination.uesrMessageLabel.text = self.userMessage;
    }
}

@end
