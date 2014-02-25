//
//  GGPEventOptionsViewController.h
//  Soiree
//
//  Created by Greg Probst on 2/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "GGPTwitterResultsViewController.h"
#import "GGPFacebookResultsViewController.h"
#import "GGPStatsViewController.h"

@interface GGPEventOptionsViewController : UITableViewController<UIActionSheetDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate,NSURLConnectionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *photoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *logSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *contentSwitch;
@property (weak, nonatomic) IBOutlet PFObject *event;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UITextField *hashtagSearch;
@property (weak, nonatomic) IBOutlet UITableViewCell *twitterSearchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *facebookSearchCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *statsCell;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *buffer;
@property (nonatomic,strong) NSMutableArray *results;

- (IBAction)pressContentSwitch:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)pressLogSwitch:(id)sender;
- (IBAction)pressPhotoSwitch:(id)sender;
- (IBAction)pressVideoSwitch:(id)sender;

@end
