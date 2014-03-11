//
//  GGPFindEventViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/14/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Parse/Parse.h>
#import "GGPLocation.h"
#import "GGPEvent.h"
#import "GGPEventDetailViewController.h"
#import <MapKit/MapKit.h>
#import "GGPSearchViewController.h"

@interface GGPFindEventViewController : PFQueryTableViewController<UIAlertViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)search:(id)sender;
- (IBAction)setToday:(id)sender;
- (IBAction)setWeek:(id)sender;
- (IBAction)setMonth:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;


@end
