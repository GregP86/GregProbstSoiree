//
//  GGPEventLogViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "GGPComposeEntryViewController.h"
#import "GGPVideoEntryViewController.h"
#import "GGPTextFilter.h"
#import "GGPCollectionLayout.h"
#import "GGPLabelConverter.h"
#import "GGPSlideshowViewController.h"
#import "GGPSlideshowOptions.h"
#import "GGPSlideShowOptionsViewController.h"
#import "GGPLogEditViewController.h"

@interface GGPEventLogViewController : UICollectionViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic) PFObject *event;
@property(strong, nonatomic) NSMutableArray *dbobjects;
@property(strong, nonatomic) NSMutableArray *LogEntries;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) GGPSlideshowOptions *options;



@end
