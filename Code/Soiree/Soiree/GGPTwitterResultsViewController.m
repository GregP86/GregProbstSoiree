//
//  GGPTwitterResultsViewController.m
//  Soiree
//
//  Created by Greg Probst on 2/5/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPTwitterResultsViewController.h"

@interface GGPTwitterResultsViewController (){
    NSMutableArray *checkArray;
    
}

@end

@implementation GGPTwitterResultsViewController

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
    
    NSNumber *noObj = [NSNumber numberWithBool:NO];
    
    checkArray = [[NSMutableArray alloc] init];
    for (int count = 0; count < self.results.count; count++) {
        [checkArray addObject:noObj];
    }
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *tweet = (self.results)[indexPath.row];
    for(NSObject *o in tweet){
        NSLog(@"%@",o.description);
    }
    NSString *text = [NSString stringWithFormat:@"%@ - %@", tweet[@"text"], [tweet[@"user"] objectForKey:@"name"]];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 5;
//    if (checkArray[indexPath.row] == yesObj) {
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//    }
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSNumber *yesObj = [NSNumber numberWithBool:YES];
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    checkArray[indexPath.row] = yesObj;
//    
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    
//}
//
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSNumber *noObj = [NSNumber numberWithBool:NO];
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//     checkArray[indexPath.row] = noObj;
//    
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}




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

- (IBAction)addToLog:(id)sender {
    NSArray * selectedCells = [self.tableView indexPathsForSelectedRows];

    for (NSIndexPath *indexPath in selectedCells) {
        NSDictionary *tweet = (self.results)[indexPath.row];
        PFObject *post = [PFObject objectWithClassName:@"LogEntry"];
        post[@"Data"] = [NSNull null];
        post[@"FileType"] = @"TXT";
        post[@"Text"] = tweet[@"text"];
        post[@"isIncluded"] = @1;
        post[@"SubmittedBy"] = [tweet[@"user"] objectForKey:@"name"];
        post[@"eventID"] = [self.event objectId];
        
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.event addObject:[post objectId] forKey:@"Log"];
                [self.event saveInBackground];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];

    }
}
@end
