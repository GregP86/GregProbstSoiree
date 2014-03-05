//
//  GGPLogEditViewController.h
//  Soiree
//
//  Created by Greg Probst on 3/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGPLogEntry.h"

@interface GGPLogEditViewController : UITableViewController

@property (strong, nonatomic) PFObject *event;
@property (strong, nonatomic) NSMutableArray *LogEntries;
@property (weak, nonatomic) IBOutlet UIImageView *deleteButton;
- (IBAction)delete:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
