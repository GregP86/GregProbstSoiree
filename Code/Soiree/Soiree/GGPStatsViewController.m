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
    self.underEighteenLabel.text = [NSString stringWithFormat:@"%.02f%%",[stats percentUnderEighteen]];
    self.nineteenToTwentyfiveLabel.text = [NSString stringWithFormat:@"%.02f%%",[stats percentEighteenToTwentyfive]];
    self.twentysixToThirtyfive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentTwentyfiveToThirtyfive]];
    self.thirtysixToFourtyfive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentThirtyfiveToFourtyFive]];
    self.fourtysixToFiftyfive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentFourtyfiveToFiftyfive]];
    self.fiftyfivePlusLabel.text = [NSString stringWithFormat:@"%.02f%%", [stats percentGreaterThanFiftyFive]];
    self.webView.layer.cornerRadius = 5;
    [self.webView setClipsToBounds:YES];
    self.webView.layer.borderColor = [[UIColor blackColor]CGColor];
    self.webView.layer.borderWidth = 2;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[GGPWordCloudRetriever getWordCloudUrl:self.event]];
    
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
