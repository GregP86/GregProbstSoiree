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
    PFGeoPoint *currentLocation;
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
    self.objectEvent = [GGPEvent restoreFromDB:self.event];
    isJoined = NO;
    isJoined = [self.objectEvent.Attendees containsObject:[PFUser currentUser].username];
    
    NSString *string = [PFUser currentUser].username;
    
    if(isJoined){
        [self.joinButton setTitle:@"Leave" forState:UIControlStateNormal];
    }else if([self.objectEvent.creator isEqualToString:string]){
        [self.joinButton setTitle:@"Options" forState:UIControlStateNormal];
    }else{
        [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
    }
    
    self.title = self.objectEvent.eventTitle;
    self.DetailsView.text = self.objectEvent.eventDescription;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EE MMM dd, yy 'at' h:mm"];
    NSString *startString = [formatter stringFromDate:self.objectEvent.startTime];
    NSString *endString = [formatter stringFromDate:self.objectEvent.endTime];
    
    self.startTimeLabel.text = startString;
    self.endTimeLabel.text = endString;
    
    self.AddressView.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", self.objectEvent.realLocation.streetAddress,
                                                                            self.objectEvent.realLocation.city,
                                                                            self.objectEvent.realLocation.state,
                                                                            self.objectEvent.realLocation.zip
                             ];
    
    self.map.showsUserLocation = YES;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D location;
    location.latitude = self.objectEvent.realLocation.latitude;
    location.longitude = self.objectEvent.realLocation.longitude;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (location, 5000, 5000);
    [self.map setRegion:region animated:YES];
    
    [point setCoordinate:(location)];
    [point setTitle:self.objectEvent.eventTitle];
    
    [self.map addAnnotation:point];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            currentLocation = geoPoint;
        }
    }];


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
        [self leaveEvent];
    }else if([self.joinButton.titleLabel.text isEqualToString:@"Options"]){
        [self performSegueWithIdentifier:@"toOptions" sender:self];
    }else{
        PFGeoPoint *loc = [PFGeoPoint geoPointWithLatitude:self.objectEvent.realLocation.latitude longitude: self.objectEvent.realLocation.longitude];
        double distanceFromEvent = [loc distanceInMilesTo:currentLocation];
        if (distanceFromEvent < .5) {
            [self.event addUniqueObject:[PFUser currentUser].username forKey:@"Attendees"];
            [self.event saveInBackground];
            [self.joinButton setTitle:@"Leave" forState:UIControlStateNormal];
        } else{
            [self showAlertView];
        }
        
    }
    
}

-(void)leaveEvent{
    [self.event removeObject:[PFUser currentUser].username forKey:@"Attendees"];
    [self.event saveInBackground];
    [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];

}




-(void)showAlertView{
    UIAlertView *tooFarAlert = [[UIAlertView alloc]initWithTitle:@"Too far from event." message:@"You must be within 0.25 miles of the event to join it" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
    [tooFarAlert show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toAttendees"]) {
        GGPAttendeesViewController *destination = segue.destinationViewController;
        destination.eventId = self.objectEvent.idString;
    } else if ([segue.identifier isEqualToString:@"toEventLog"]) {
        GGPEventLogViewController *destination = segue.destinationViewController;
        destination.event = self.event;
    }else if ([segue.identifier isEqualToString:@"toOptions"]) {
        GGPEventOptionsViewController *destination = segue.destinationViewController;
        destination.event = self.event;
    }
}

@end












