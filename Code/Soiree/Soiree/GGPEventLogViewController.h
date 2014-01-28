//
//  GGPEventLogViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGPComposeEntryViewController.h"
#import "GGPVideoEntryViewController.h"

@interface GGPEventLogViewController : UICollectionViewController

@property(strong, nonatomic) PFObject *event;

@end
