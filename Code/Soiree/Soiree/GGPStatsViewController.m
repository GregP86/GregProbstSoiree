//
//  GGPStatsViewController.m
//  Soiree
//
//  Created by Greg Probst on 2/24/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPStatsViewController.h"

@interface GGPStatsViewController (){
    GGPStats *stats;
}

@end

@implementation GGPStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    stats = [[GGPStats alloc]initWithEvent:self.event];
    self.totalAttendeesLabel.text =  [NSString stringWithFormat:@"%d",stats.totalCount];
    self.totalWomenLabel.text = [NSString stringWithFormat:@"%d",stats.femaleCount];
    self.totalMendLabel.text = [NSString stringWithFormat:@"%d",stats.maleCount];
    self.MFRatio.text = [NSString stringWithFormat:@"%@",[stats ratioMaleToFemale]];
    //self.underEighteenLabel.text =

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end