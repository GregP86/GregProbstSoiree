//
//  GGPViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/6/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPCreateUserViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "GGPEvent.h"
#import "GGPEventDetailViewController.h"
#import "GGPEventLogViewController.h"

@interface GGPViewController : UIViewController<MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cellButton;
@property (weak, nonatomic) IBOutlet UILabel *uesrMessageLabel;

- (IBAction)createEventButton:(id)sender;
- (IBAction)popOverMenu:(id)sender;
- (IBAction)logOut:(id)sender;
- (void)addToLog:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *nearbtEventsMap;
@property (weak, nonatomic) IBOutlet UITableView *myEventsTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *front;

@end
