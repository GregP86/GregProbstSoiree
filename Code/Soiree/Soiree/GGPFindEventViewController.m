    //
//  GGPFindEventViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/14/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPFindEventViewController.h"

@interface GGPFindEventViewController (){
    PFGeoPoint *currentLocation;
    NSMutableArray *events;
    PFObject *selectedEvent;
    int direction;
    int shakes;
    NSDate *start;
    
}

@end

@implementation GGPFindEventViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        [self.indicator startAnimating];
                self.parseClassName = @"Location";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 7;
        
        start = [NSDate date];
        int daysToAdd = 1;
        start = [start dateByAddingTimeInterval:60*60*24 * daysToAdd];
        
        
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                currentLocation = geoPoint;
                [self loadObjects];
            }
        }];
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    if(!currentLocation){
        return nil;
    }
    PFQuery *innerQuery = [PFQuery queryWithClassName:self.parseClassName];
    [innerQuery whereKey:@"Coords" nearGeoPoint:currentLocation];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    //query.cachePolicy = kPFCachePolicyIgnoreCache;
    [query whereKey:@"Location" matchesQuery:innerQuery];
    [query whereKey:@"EndTime" greaterThanOrEqualTo:[NSDate date]];
    [query whereKey:@"StartTime" lessThanOrEqualTo:start];
    [query setLimit:10];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    
    static NSString *cellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    if(object[@"Password"] != [NSNull null]){
        UIImageView * view = (UIImageView *)[cell viewWithTag:1234];
        view.image = [UIImage imageNamed:@"lock.png"];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[@"Title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 object[@"Description"]];
    
    return cell;
}

- (void)createObjectsArray
{
    events = [NSMutableArray array];
    for(PFObject *o in self.objects){
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
        [events addObject:event];
    }
}

-(void)populateMap{
    self.map.showsUserLocation = YES;
    CLLocationCoordinate2D cllocation;
    cllocation.latitude = currentLocation.latitude;
    cllocation.longitude = currentLocation.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (cllocation, 20000, 20000);
    [self.map setRegion:region animated:YES];
}

-(void)addPinPoints{
    for(GGPEvent *e in events){
       MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D location;
        location.latitude = e.realLocation.latitude;
        location.longitude = e.realLocation.longitude;
        [point setCoordinate:(location)];
        [point setTitle:e.eventTitle];
        
        [self.map addAnnotation:point];
        
    }
}

-(void)objectsDidLoad:(NSError *)error{
    
    [super objectsDidLoad:error];
    [self createObjectsArray];
    [self populateMap];
    [self addPinPoints];
    [self.indicator stopAnimating];
}

-(void)viewDidLoad{
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
    self.tableView.delegate = self;
    self.map.delegate = self;
    [self.todayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.todayButton setUserInteractionEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if([[alertView textFieldAtIndex:0].text isEqualToString:selectedEvent[@"Password"]]){
            [self performSegueWithIdentifier:@"eventDetail" sender:self];
        }else{
            
        }
    }
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    BOOL result = YES;
    if([identifier isEqualToString:@"eventDetail"]){
        selectedEvent = self.objects[[self.tableView indexPathForSelectedRow].row];
        if(![selectedEvent[@"Password"] isEqual:[NSNull null]]){
            [self showAlertView];
            result = NO;
        }
    }
    
    return result;
        
}

-(void)showAlertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password" message:@"This event is private, enter the password:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.delegate = self;
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"eventDetail"] && [sender isKindOfClass: [MKAnnotationView class]]) {
        MKAnnotationView *annotationView = sender;
        GGPEventDetailViewController *destination = segue.destinationViewController;
        PFObject *passObject;
        for (PFObject *obj in self.objects) {
            if([obj[@"Title"] isEqualToString:annotationView.annotation.title]){
                passObject = obj;
            }
        }
        destination.event = passObject;
    }else if ([segue.identifier isEqualToString:@"eventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GGPEventDetailViewController *destination = segue.destinationViewController;
        destination.event = [self.objects objectAtIndex:indexPath.row];
    }else if([segue.identifier isEqualToString:@"toSearch"]){
        GGPSearchViewController *destination = segue.destinationViewController;
        destination.search = self.searchBar.text;
    }
}

- (IBAction)search:(id)sender {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (IBAction)setToday:(id)sender {
    [self.indicator startAnimating];
    [self.todayButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.todayButton setUserInteractionEnabled:NO];
    [self.weekButton setTitleColor:[UIColor colorWithRed:76.0f/255.0f green:202.0f/255.0f blue:205.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.weekButton setUserInteractionEnabled:YES];
    [self.monthButton setTitleColor:[UIColor colorWithRed:76.0f/255.0f green:202.0f/255.0f blue:205.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.monthButton setUserInteractionEnabled:YES];
    start = [NSDate date];
    int addDays = 1;
    start = [start dateByAddingTimeInterval:60*60*24*addDays];
    [self.map removeAnnotations:self.map.annotations];
    [self loadObjects];
    
}

- (IBAction)setWeek:(id)sender {
    [self.indicator startAnimating];
    [self.weekButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.weekButton setUserInteractionEnabled:NO];
    [self.todayButton setTitleColor:[UIColor colorWithRed:76.0f/255.0f green:202.0f/255.0f blue:205.0f/255.0f alpha:1.0]forState:UIControlStateNormal];
    [self.todayButton setUserInteractionEnabled:YES];
    [self.monthButton setTitleColor:[UIColor colorWithRed:76.0f/255.0f green:202.0f/255.0f blue:205.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.monthButton setUserInteractionEnabled:YES];
    start = [NSDate date];
    int addDays = 7;
    start = [start dateByAddingTimeInterval:60*60*24*addDays];
    [self.map removeAnnotations:self.map.annotations];
    [self loadObjects];
}

- (IBAction)setMonth:(id)sender {
    [self.indicator startAnimating];
    [self.monthButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.monthButton setUserInteractionEnabled:NO];
    [self.todayButton setTitleColor:[UIColor colorWithRed:76.0f/255.0f green:202.0f/255.0f blue:205.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.todayButton setUserInteractionEnabled:YES];
    [self.weekButton setTitleColor:[UIColor colorWithRed:76.0f/255.0f green:202.0f/255.0f blue:205.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.weekButton setUserInteractionEnabled:YES];
    start = [NSDate date];
    int addDays = 30;
    start = [start dateByAddingTimeInterval:60*60*24*addDays];
    [self.map removeAnnotations:self.map.annotations];
    [self loadObjects];
}

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
    for (PFObject *obj in self.objects) {
        if([obj[@"Title"] isEqualToString: view.annotation.title]){
            if (obj[@"Password"] != [NSNull null]) {
                selectedEvent = obj;
                [self showAlertView];
            }else{
                [self performSegueWithIdentifier:@"eventDetail" sender:view];
            }
        }
    }
}
@end
