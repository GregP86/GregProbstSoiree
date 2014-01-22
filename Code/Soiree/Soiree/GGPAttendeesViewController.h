//
//  GGPAttendeesViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/21/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GGPAttendeesViewController : UITableViewController

@property (weak, nonatomic) NSString *eventId;
@property (weak, nonatomic) PFObject *object;
@property (weak, nonatomic) NSArray *attendees;

@end
