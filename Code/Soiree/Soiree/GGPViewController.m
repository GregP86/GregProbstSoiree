//
//  GGPViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/6/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPViewController.h"

@interface GGPViewController ()

@end

@implementation GGPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [PFUser logOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returned:(UIStoryboardSegue *)segue{
    
}

- (IBAction)createEventButton:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        [self performSegueWithIdentifier:@"createEvent" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"logIn" sender:nil];
    }
}
@end
