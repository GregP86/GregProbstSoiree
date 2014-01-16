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
#import <MapKit/MapKit.h>

@interface GGPFindEventViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
