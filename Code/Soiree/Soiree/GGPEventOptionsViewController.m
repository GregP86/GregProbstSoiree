//
//  GGPEventOptionsViewController.m
//  Soiree
//
//  Created by Greg Probst on 2/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPEventOptionsViewController.h"

@interface GGPEventOptionsViewController ()

@end

@implementation GGPEventOptionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self.event[@"isFiltered"] isEqual: @1]){
        [self.contentSwitch setOn:YES];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pressContentSwitch:(id)sender {
    
    self.event[@"isFiltered"] = [self.event[@"isFiltered"] isEqual:@1]? @0:@1;
}

- (IBAction)deleteButton:(id)sender {
    [self showActionSheet];
}

-(void)showActionSheet{
    UIActionSheet *deleteSheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    [deleteSheet showFromBarButtonItem:self.barButton animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.event deleteInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
