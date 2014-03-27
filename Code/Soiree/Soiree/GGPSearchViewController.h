//
//  GGPSearchViewController.h
//  Soiree
//
//  Created by Greg Probst on 3/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Parse/Parse.h>
#import "GGPEventDetailViewController.h"
#import "GGPHash.h"

@interface GGPSearchViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)searchButton:(id)sender;
@property (weak, nonatomic) IBOutlet NSString *search;

@end
