//
//  GGPDeleteCell.h
//  Soiree
//
//  Created by Greg Probst on 3/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPLogEntry.h"
#import "GGPLogEditViewController.h"

@interface GGPDeleteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) PFObject *event;
@property (strong, nonatomic) GGPLogEntry *log;
- (IBAction)deleteEvent:(id)sender;


@end
