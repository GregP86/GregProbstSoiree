//
//  GGPStatsViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/24/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGPStats.h"
#import "GGPWordCloudRetriever.h"
#import <QuartzCore/QuartzCore.h>

@interface GGPStatsViewController : UIViewController

@property (strong,nonatomic) PFObject *event;

@property (weak, nonatomic) IBOutlet UILabel *totalAttendeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWomenLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMendLabel;
@property (weak, nonatomic) IBOutlet UILabel *MFRatio;

@property (weak, nonatomic) IBOutlet UILabel *underEighteenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nineteenToTwentyfiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *twentysixToThirtyfive;
@property (weak, nonatomic) IBOutlet UILabel *thirtysixToFourtyfive;
@property (weak, nonatomic) IBOutlet UILabel *fourtysixToFiftyfive;
@property (weak, nonatomic) IBOutlet UILabel *fiftyfivePlusLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
