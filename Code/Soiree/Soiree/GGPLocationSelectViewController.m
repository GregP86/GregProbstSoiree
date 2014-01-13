//
//  GGPLocationSelectViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLocationSelectViewController.h"

@interface GGPLocationSelectViewController ()

@end

@implementation GGPLocationSelectViewController

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
    self.map.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myLocation:(id)sender {
    MKUserLocation *userLocation = self.map.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000);
    [self.map setRegion:region animated:YES];
    
}
@end
