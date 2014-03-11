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
    NSMutableArray *joinedEvents;
    NSString *parseClassName;
    NSString *textKey;
    BOOL isFirst, firstLoad;
    PFObject  *selectedEvent;
    NSMutableArray *buttonData;
}

@end

@implementation GGPViewController

- (void)viewDidLoad
{
    //self.frontView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"fabric_plaid.png"]];
    
    [self.indicator startAnimating];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   //[PFUser logOut];
    self.nearbtEventsMap.delegate = self;
    self.myEventsTable.delegate = self;
    self.myEventsTable.dataSource = self;
    
    self.myEventsTable.layer.cornerRadius = 10;
    self.myEventsTable.layer.borderWidth = 2;
    //self.myEventsTable.layer.borderColor = [UIColor colorWithRed:23 green:35 blue:47 alpha:1].CGColor;
    self.myEventsTable.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.myEventsTable.bounces = YES;
    self.myEventsTable.allowsMultipleSelectionDuringEditing = YES;
    //self.midView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"grey_wash.png"]];
    
    //UIImage *image = [UIImage imageNamed:@"grey_wash.png"];
    //self.navigationController.navigationBar.layer.borderWidth = 2;
    //self.navigationController.navigationBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    //self.midView.layer.cornerRadius = 5;
    self.userLabel.text = [NSString stringWithFormat:@"Hello, %@",[PFUser currentUser].username];
    parseClassName = @"Location";
    
    textKey = @"text";
    isFirst = YES;
    firstLoad = YES;

    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            currentLocation = geoPoint;
            isFirst = YES;
            [self loadObjects];
            
        }
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (!firstLoad) {
        [self.indicator startAnimating];
        isFirst = YES;
        [self performSelector:@selector(loadObjects) withObject:nil afterDelay:0.1];
    }
    firstLoad = NO;
    
}

-(void)loadObjects{
    
    [self.nearbtEventsMap removeAnnotations:self.nearbtEventsMap.annotations];
    
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
    [self.myEventsTable reloadData];
    [self setUpButtons];
    [self.indicator stopAnimating];
}

-(void)setUpButtons{
    
    buttonData = [[NSMutableArray alloc] init];
    PFQuery *images = [PFQuery queryWithClassName:@"LogEntry"];
    [images whereKey:@"FileType" containsString:@"JPEG"];
    NSArray *results=[images findObjects];
    
    int r = arc4random() % results.count;
    PFFile *tempFile = results[r][@"Data"];
    NSData *image = [tempFile getData];
    [self.bigImage setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
    [self.bigImage.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.bigImage.layer.borderColor =[UIColor darkGrayColor].CGColor;
    self.bigImage.layer.borderWidth = 2;
    PFObject *obj = [PFQuery getObjectOfClass:@"Event" objectId:results[r][@"eventID"]];
    [buttonData addObject:obj];
    self.bigLabel.text = obj[@"Title"];
    [self.bigImage setTag:0];
    [self.bigImage addTarget:self action:@selector(bigImageTap:) forControlEvents:UIControlEventTouchUpInside];
    
    r = arc4random() % results.count;
    tempFile = results[r][@"Data"];
    image = [tempFile getData];
    [self.leftButton setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
    [self.leftButton.imageView setContentMode:UIViewContentModeScaleAspectFill ];
    self.leftButton.layer.borderColor =[UIColor darkGrayColor].CGColor;
    self.leftButton.layer.borderWidth = 2;
    obj = [PFQuery getObjectOfClass:@"Event" objectId:results[r][@"eventID"]];
    [buttonData addObject:obj];
    [self.leftButton setTag:1];
    self.leftLabel.text = obj[@"Title"];
    [self.leftButton addTarget:self action:@selector(bigImageTap:) forControlEvents:UIControlEventTouchUpInside];
    
    r = arc4random() % results.count;
    tempFile = results[r][@"Data"];
    image = [tempFile getData];
    [self.rightButton setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
    [self.rightButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.rightButton.layer.borderColor =[UIColor darkGrayColor].CGColor;
    self.rightButton.layer.borderWidth = 2;
    obj = [PFQuery getObjectOfClass:@"Event" objectId:results[r][@"eventID"]];
    [buttonData addObject:obj];
    [self.rightButton setTag:2];
    self.rightLabel.text = obj[@"Title"];
    [self.rightButton addTarget:self action:@selector(bigImageTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) bigImageTap: (id) sender{
    [self performSegueWithIdentifier:@"toDetail" sender:sender];
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

-(void)createMyEventsArray{
    joinedEvents = [[NSMutableArray alloc]init];
    myEvents = [[PFUser currentUser] objectForKey:@"Events"];
    
    for(NSString *s in myEvents){
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        PFObject *temp =[query getObjectWithId:s];
        [joinedEvents addObject:temp];
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

-(void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password" message:@"This event is private, enter the password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.delegate = self;
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if([[alertView textFieldAtIndex:0].text isEqualToString:selectedEvent[@"Password"]]){
            [self performSegueWithIdentifier:@"toDetail" sender:self];
        }else{
            
        }
    }
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
            PFObject *temp =[joinedEvents objectAtIndex:cell.tag];
            destination.event = temp;
        }else if([segue.identifier isEqualToString:@"toDetail"] && [sender isKindOfClass: [UIButton class]]){
            UIButton * button = sender;
            GGPEventDetailViewController *destination = segue.destinationViewController;
            destination.event = buttonData[button.tag];
        }
        else if([segue.identifier isEqualToString:@"toDetail"]){
            GGPEventDetailViewController *destination = segue.destinationViewController;
            destination.event = selectedEvent;
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

-(void)pullUpEvents:(id)sender{
    
    CGRect destination = self.myEventsTable.frame;
    
    if (destination.origin.y < 210) {
        destination.origin.y = 210;
    } else {
        destination.origin.y -= 225.5;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.myEventsTable.frame = destination;
        
    } completion:^(BOOL finished) {
        
        //[self.nearbtEventsMap setUserInteractionEnabled:!self.nearbtEventsMap.userInteractionEnabled];
        [self.view bringSubviewToFront:self.myEventsTable];
    }];
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
    for (PFObject *obj in events) {
        if([obj[@"Title"] isEqualToString: view.annotation.title]){
            if (obj[@"Password"] != [NSNull null]) {
                selectedEvent = obj;
                [self showAlertView];
            }else{
                [self performSegueWithIdentifier:@"toDetail" sender:view];
            }
        }
    }
}

#pragma mark tableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self createMyEventsArray];
    return joinedEvents.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"topCell" forIndexPath:indexPath];
        isFirst = NO;
    }else{
        long num = (indexPath.row);
        PFObject *temp = joinedEvents[num -1];
    
        static NSString *CellIdentifier = @"Cell";
  
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:5];
        UIButton *button = (UIButton *)[cell viewWithTag:6];
        [button addTarget:self action:@selector(addToLog:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:indexPath.row];
        label.text = temp[@"Title"];
        if (num == joinedEvents.count) {
            isFirst = YES;
        }
    }
    
    return cell;
}
#pragma mark tableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        
    }else{
    
        UITableViewCell  *cell = [self.myEventsTable cellForRowAtIndexPath:indexPath];
        [cell setTag:indexPath.row - 1];
        [self performSegueWithIdentifier:@"toDetail" sender:cell];
    }
}
//-(void)viewWillDisappear:(BOOL)animated{
//     currentLocation = nil;
//     events = nil;
//     moEvents = nil;
//     myEvents = nil;
//     joinedEvents = nil;
//     parseClassName = nil;
//     textKey = nil;
//     isFirst = nil;
//     selectedEvent = nil;
//     buttonData = nil;
//}

@end
