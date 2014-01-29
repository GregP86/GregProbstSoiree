//
//  GGPEventLogViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPEventLogViewController.h"

@interface GGPEventLogViewController ()

@end

@implementation GGPEventLogViewController

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEntryCompose"]){
        GGPComposeEntryViewController *vcImage = [[GGPComposeEntryViewController alloc] init];
        UITabBarController* tbc = [segue destinationViewController];
        vcImage = (GGPComposeEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:0];
        
        vcImage.event = self.event;
    }

}

-(IBAction)toLog:(UIStoryboardSegue *)segue{
    
}

@end
