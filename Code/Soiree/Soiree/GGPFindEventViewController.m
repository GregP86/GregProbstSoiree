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
}

@end

@implementation GGPFindEventViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"Location";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
        
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
    [query whereKey:@"Location" matchesQuery:innerQuery];
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
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"eventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GGPEventDetailViewController *destination = segue.destinationViewController;
        destination.event = [self.objects objectAtIndex:indexPath.row];
    }
}

@end
