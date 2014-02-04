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

@interface GGPEventLogViewController : UICollectionViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic) PFObject *event;
@property(strong, nonatomic) NSMutableArray *dbobjects;
@property(strong, nonatomic) NSMutableArray *LogEntries;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end
