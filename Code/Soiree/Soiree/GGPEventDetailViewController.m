//
//  GGPEventDetailViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/16/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPEventDetailViewController.h"

@interface GGPEventDetailViewController (){
    BOOL isJoined;
}

@end

@implementation GGPEventDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GGPEvent *objectEvent = [GGPEvent restoreFromDB:self.event];
    isJoined = NO;
    isJoined = [objectEvent.Attendees containsObject:[PFUser currentUser].username];
    
    NSString *string = [PFUser currentUser].username;
    
    if(isJoined){
        [self.joinButton setTitle:@"Leave" forState:UIControlStateNormal];
    }else if([objectEvent.creator isEqualToString:string]){
        [self.joinButton setTitle:@"Delete" forState:UIControlStateNormal];
    }else{
        [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
    }
    
    self.title = objectEvent.eventTitle;
    self.DetailsView.text = objectEvent.eventDescription;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EE MMM dd, yy 'at' h:mm"];
    NSString *startString = [formatter stringFromDate:objectEvent.startTime];
    NSString *endString = [formatter stringFromDate:objectEvent.endTime];
    
    self.startTimeLabel.text = startString;
    self.endTimeLabel.text = endString;
    
    self.AddressView.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", objectEvent.realLocation.streetAddress,
                                                                            objectEvent.realLocation.city,
                                                                            objectEvent.realLocation.state,
                                                                            objectEvent.realLocation.zip
                             ];
    
    self.map.showsUserLocation = YES;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D location;
    location.latitude = objectEvent.realLocation.latitude;
    location.longitude = objectEvent.realLocation.longitude;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (location, 5000, 5000);
    [self.map setRegion:region animated:YES];
    
    [point setCoordinate:(location)];
    [point setTitle:objectEvent.eventTitle];
    
    [self.map addAnnotation:point];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)joinEventButton:(id)sender {
    if([self.joinButton.titleLabel.text isEqualToString:@"Leave"]){
        
    }
}
@end












