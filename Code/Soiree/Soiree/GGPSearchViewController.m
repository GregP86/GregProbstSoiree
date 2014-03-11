//
//  GGPSearchViewController.m
//  Soiree
//
//  Created by Greg Probst on 3/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPSearchViewController.h"

@interface GGPSearchViewController (){
    PFObject *selectedEvent;
}

@end

@implementation GGPSearchViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Event";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 7;
        
    }
    return self;
}

-(PFQuery *)queryForTable{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"Title" containsString:self.search];
    [query whereKey:@"EndTime" greaterThanOrEqualTo:[NSDate date]];
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
        UIImageView * view = (UIImageView *)[cell viewWithTag:4321];
        view.image = [UIImage imageNamed:@"lock.png"];
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

- (IBAction)searchButton:(id)sender {
    self.search = self.searchBar.text;
    [self loadObjects];
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
    
    if ([segue.identifier isEqualToString:@"eventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GGPEventDetailViewController *destination = segue.destinationViewController;
        destination.event = [self.objects objectAtIndex:indexPath.row];
    }
}


@end
