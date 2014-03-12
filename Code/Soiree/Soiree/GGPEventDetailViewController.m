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
    NSString *string;
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
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:20],
                                                                     NSFontAttributeName,
                                                                     nil]];
    self.navigationController.toolbarHidden=YES;
    self.objectEvent = [GGPEvent restoreFromDB:self.event];
    isJoined = NO;
    isJoined = [self.objectEvent.Attendees containsObject:[PFUser currentUser].objectId];
    
    string = [PFUser currentUser].username;
    
    if(isJoined){
        [self.joinButton setTitle:@"Leave" forState:UIControlStateNormal];
    }else if([self.objectEvent.creator isEqualToString:string]){
        [self.joinButton setTitle:@"Options" forState:UIControlStateNormal];
    }else{
        [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
        NSIndexPath *path =[NSIndexPath indexPathForRow:1 inSection:2];
        self.logLabel.textColor = [UIColor lightGrayColor];
        self.logLabel.text = @"Join this event to contribute.";
        [self.tableView cellForRowAtIndexPath:path].userInteractionEnabled = NO;
    }
    
    if(!self.objectEvent.isPublicLog && ![string isEqualToString:self.objectEvent.creator]){
        self.logLabel.text = @"Add to Log";
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
         NSIndexPath *path =[NSIndexPath indexPathForRow:1 inSection:2];
        self.logLabel.textColor = [UIColor lightGrayColor];
        self.logLabel.text = @"Join this event to contribute.";
         [self.tableView cellForRowAtIndexPath:path].userInteractionEnabled = NO;
        isJoined = NO;
    }else if([self.joinButton.titleLabel.text isEqualToString:@"Options"]){
        [self performSegueWithIdentifier:@"toOptions" sender:self];
    }else{
        PFGeoPoint *loc = [PFGeoPoint geoPointWithLatitude:self.objectEvent.realLocation.latitude longitude: self.objectEvent.realLocation.longitude];
        double distanceFromEvent = [loc distanceInMilesTo:currentLocation];
        if (distanceFromEvent < .5) {
            [self.event addUniqueObject:[PFUser currentUser].objectId forKey:@"Attendees"];
            [self.event saveInBackground];
            [[PFUser currentUser] addUniqueObject:[self.event objectId] forKey:@"Events"];
            [[PFUser currentUser] saveInBackground];
            [self.joinButton setTitle:@"Leave" forState:UIControlStateNormal];
            NSIndexPath *path =[NSIndexPath indexPathForRow:1 inSection:2];
            self.logLabel.textColor = [UIColor blackColor];
            self.logLabel.text = @"Event Log";
            [self.tableView cellForRowAtIndexPath:path].userInteractionEnabled = YES;
            isJoined = YES;
        } else{
            [self showAlertView];
        }
        
    }
    
}

-(void)leaveEvent{
    [self.event removeObject:[PFUser currentUser].username forKey:@"Attendees"];
    [self.event saveInBackground];
    [[PFUser currentUser] removeObject:[self.event objectId] forKey:@"Events"];
    [[PFUser currentUser] saveInBackground];
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
    }else if ([segue.identifier isEqualToString:@"toSubmit"]){
        GGPComposeEntryViewController *vcImage = [[GGPComposeEntryViewController alloc] init];
        UITabBarController* tbc = [segue destinationViewController];
        vcImage = (GGPComposeEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:0];
        vcImage.event = self.event;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.section == 2) && (indexPath.row == 1)){
        
        string = [PFUser currentUser].username;
        [self.indicator startAnimating];
        [self performSelector:@selector(segueStuff) withObject:nil afterDelay:0.1];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.indicator stopAnimating];
}

-(void)segueStuff{
    if (isJoined || [string isEqualToString:self.objectEvent.creator]) {
        if (self.objectEvent.isPublicLog || [string isEqualToString:self.objectEvent.creator]) {
            [self performSegueWithIdentifier:@"toEventLog" sender:self];
        }else{
            [self performSegueWithIdentifier:@"toSubmit" sender:self];
        }
    }

}
@end












