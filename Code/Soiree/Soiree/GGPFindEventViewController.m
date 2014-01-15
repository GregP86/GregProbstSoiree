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
            }
        }];
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *innerQuery = [PFQuery queryWithClassName:self.parseClassName];
    [innerQuery whereKey:@"Coords" nearGeoPoint:currentLocation];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"Location" equalTo:innerQuery];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
