//
//  GGPTwitterResultsViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/5/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GGPTwitterResultsViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *results;
@property (nonatomic, strong) PFObject *event;

- (IBAction)addToLog:(id)sender;

@end
