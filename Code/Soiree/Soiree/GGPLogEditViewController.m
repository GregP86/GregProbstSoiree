//
//  GGPLogEditViewController.m
//  Soiree
//
//  Created by Greg Probst on 3/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLogEditViewController.h"

@interface GGPLogEditViewController (){
    int count;
}

@end

@implementation GGPLogEditViewController

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
    count = 0;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.LogEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell viewWithTag:1000];
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1002];
    
    [button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:count];
    
    GGPLogEntry *entry = self.LogEntries[indexPath.row];
    count++;
    UIImage *image = [UIImage imageWithData:entry.file];
    
    label.text = [entry.text isEqual:[NSNull null]]? @"No text": entry.text;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = image;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)delete:(id)sender {
    UIButton *button = sender;
    GGPLogEntry *entry = self.LogEntries[button.tag];
    
    PFQuery *query = [PFQuery queryWithClassName:@"LogEntry"];
    [query getObjectInBackgroundWithId:entry.id block:^(PFObject *entryObj, NSError *error) {
        [entryObj deleteInBackground];
        [self.event removeObjectsInArray:@[entry.id] forKey:@"Log"];
        [self.event saveInBackground];
    }];
    
    [self.LogEntries removeObjectAtIndex:button.tag];
    [self.tableView reloadData];
}
@end
