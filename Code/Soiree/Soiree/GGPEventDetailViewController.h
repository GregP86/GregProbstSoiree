//
//  GGPEventDetailViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/16/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GGPEvent.h"

@interface GGPEventDetailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextView *DetailsView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *AddressView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) PFObject *event;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;


@property (weak, nonatomic) IBOutlet UIButton *joinEventButton;

@end
