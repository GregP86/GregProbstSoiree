//
//  GGPCreateEventViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/9/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPCreateEventViewController.h"

@interface GGPCreateEventViewController (){
    BOOL startTimeEdited, endTimeEdited, passwordEdit;
}


@end

@implementation GGPCreateEventViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    startTimeEdited = NO;
    endTimeEdited = NO;
    passwordEdit = NO;
}

//Overload of origional method called eachtime cells are created
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 1){
        if(startTimeEdited){
            return 219;
        } else{
            return 0;
        }
    }else if(indexPath.section == 2 && indexPath.row == 3){
        if(endTimeEdited){
            return 219;
        } else{
            return 0;
        }
    }else if((indexPath.section == 3 && indexPath.row == 1) || (indexPath.section == 3 && indexPath.row == 2))
        if(passwordEdit){
            return 45;
        }else{
            return 0;
        }
    else{
        return self.tableView.rowHeight;
    }
}

//If selected row equals a date picker display date picker cell is resized accordingly
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2 && indexPath.row == 0){
        startTimeEdited = !startTimeEdited;
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    } else if(indexPath.section == 2 && indexPath.row == 2){
        endTimeEdited = !endTimeEdited;
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)privateSwitch:(id)sender {
    if(self.isPrivate.on){
        passwordEdit = YES;
            }else{
        passwordEdit = NO;
    }
    [UIView animateWithDuration:.4 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3],[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    
}
@end
