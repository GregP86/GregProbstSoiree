//
//  GGPInstagramViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/26/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "InstagramKit.h"

@interface GGPInstagramViewController : UITableViewController
- (IBAction)addToLog:(id)sender;
@property (strong, nonatomic) NSMutableArray *instagramFeed;
@property (strong, nonatomic) PFObject *event;
@end
