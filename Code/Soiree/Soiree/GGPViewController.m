//
//  GGPViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/6/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPViewController.h"

@interface GGPViewController (){
    PFGeoPoint *currentLocation;
    NSArray *events;
    NSMutableArray *moEvents;
    NSMutableArray *myEvents;
    NSString *parseClassName;
    NSString *textKey;
}

@end

@implementation GGPViewController

- (void)viewDidLoad
{
    [self.indicator startAnimating];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   //[PFUser logOut];
    self.nearbtEventsMap.delegate = self;
    self.myEventsTable.delegate = self;
    self.myEventsTable.dataSource = self;
    self.myEventsTable.layer.cornerRadius = 5;
    self.nearbtEventsMap.layer.cornerRadius = 5;
    
    parseClassName = @"Location";
    
    textKey = @"text";
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            currentLocation = geoPoint;
            [self loadObjects];
        }
    }];
    
}

-(void)loadObjects{
    
   
    PFQuery *innerQuery = [PFQuery queryWithClassName:parseClassName];
    [innerQuery whereKey:@"Coords" nearGeoPoint:currentLocation];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"Location" matchesQuery:innerQuery];
    [query whereKey:@"EndTime" greaterThanOrEqualTo:[NSDate date]];
    [query setLimit:5];
    
    events = [query findObjects];
 
    [self createObjectsArray];
    [self populateMap];
    [self addPinPoints];
    [self.indicator stopAnimating];
}

- (void)createObjectsArray
{
    moEvents = [NSMutableArray array];
    for(PFObject *o in events){
        GGPEvent *event = [[GGPEvent alloc] init];
        PFObject *pflocation = o[@"Location"];
        
        [pflocation fetch];
        
        GGPLocation *location = [[GGPLocation alloc]init];
        PFGeoPoint *coords = [pflocation objectForKey: @"Coords"];
        location.latitude = coords.latitude;
        location.longitude = coords.longitude;
        location.locationName = pflocation[@"Name"];
        location.streetAddress = pflocation[@"Street"];
        location.city = pflocation[@"City"];
        location.state = pflocation[@"State"];
        location.zip = pflocation[@"Zip"];
        
        event.eventTitle = o[@"Title"];
        event.eventDescription = o[@"Description"];
        event.startTime = o[@"StartTime"];
        event.endTime = o[@"EndTime"];
        event.password = o[@"Password"];
        event.creator = o[@"Creator"];
        event.realLocation = location;
        [moEvents addObject:event];
    }
}

-(void)populateMap{
    self.nearbtEventsMap.showsUserLocation = YES;
    CLLocationCoordinate2D cllocation;
    cllocation.latitude = currentLocation.latitude;
    cllocation.longitude = currentLocation.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (cllocation, 20000, 20000);
    [self.nearbtEventsMap setRegion:region animated:YES];
}

-(void)addPinPoints{
    for(GGPEvent *e in moEvents){
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D location;
        location.latitude = e.realLocation.latitude;
        location.longitude = e.realLocation.longitude;
        [point setCoordinate:(location)];
        [point setTitle:e.eventTitle];
        
        [self.nearbtEventsMap addAnnotation:point];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)returned:(UIStoryboardSegue *)segue{}

- (IBAction)createEventButton:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        [self performSegueWithIdentifier:@"createEvent" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"logIn" sender:nil];
    }
}

- (IBAction)popOverMenu:(id)sender {
    
    CGRect destination = self.front.frame;
    
    if (destination.origin.x > 0) {
        destination.origin.x = 0;
    } else {
        destination.origin.x += 150.5;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.front.frame = destination;
        
    } completion:^(BOOL finished) {
        
        //self.backMenu.userInteractionEnabled = !(destination.origin.x > 0);
        
    }];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logOut" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDetail"] && [sender isKindOfClass: [MKAnnotationView class]]) {
        MKAnnotationView *annotationView = sender;
        GGPEventDetailViewController *destination = segue.destinationViewController;
        PFObject *passObject;
        for (PFObject *obj in events) {
            if([obj[@"Title"] isEqualToString:annotationView.annotation.title]){
                passObject = obj;
            }
        }
        
        destination.event = passObject;
    }else if([segue.identifier isEqualToString:@"toDetail"] && [sender isKindOfClass: [UITableViewCell class]]){
        UITableViewCell * cell = sender;
        GGPEventDetailViewController *destination = segue.destinationViewController;
        PFObject *passObject = [events objectAtIndex:cell.tag];
        destination.event = passObject;
    }else if([segue.identifier isEqualToString:@"Compose"] && [sender isKindOfClass:[UIButton class]]){
        UIButton *button = sender;
        GGPComposeEntryViewController *vcImage = [[GGPComposeEntryViewController alloc] init];
        UITabBarController* tbc = [segue destinationViewController];
        vcImage = (GGPComposeEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:0];
        vcImage.event = events [button.tag];
    }
}

-(void)addToLog:(UIButton *) sender{
    [self performSegueWithIdentifier:@"Compose" sender:sender];
}

-(IBAction)toLog:(UIStoryboardSegue *)segue{
    
}

#pragma mark mapView delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"toDetail" sender:view];
}

#pragma mark tableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    myEvents = [[PFUser currentUser] objectForKey:@"Events"];
    return myEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    PFObject *temp =[query getObjectWithId:[myEvents objectAtIndex:indexPath.row]];
    
    static NSString *CellIdentifier = @"Cell";
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:5];
    UIButton *button = (UIButton *)[cell viewWithTag:6];
    [button addTarget:self action:@selector(addToLog:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:indexPath.row];
    label.text = temp[@"Title"];
    
    return cell;
}
#pragma mark tableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell  *cell = [self.myEventsTable cellForRowAtIndexPath:indexPath];
    [cell setTag:indexPath.row];
    [self performSegueWithIdentifier:@"toDetail" sender:cell];
}

@end
