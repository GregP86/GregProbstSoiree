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
    [self.event saveInBackground];
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

-(void)searchTwitter{
    NSString *encodedQuery = [self.hashtagSearch.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error){
         if (granted)
         {
             NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
             NSDictionary *parameters = @{@"count" : @10,
                                          @"q" : encodedQuery};
             
             SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:url
                                                          parameters:parameters];
             
             NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
             slRequest.account = [accounts lastObject];
             
             NSURLRequest *request = [slRequest preparedURLRequest];
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                                   delegate:self];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
             });
         }
         else
         {
             //display error
         }
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.buffer = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.buffer appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:self.buffer options:0 error:&jsonParsingError];
    
    self.results = jsonResults[@"statuses"];
    if ([self.results count] == 0)
    {
//        NSArray *errors = jsonResults[@"errors"];
//        if ([errors count])
//        {
//            self.searchState = UYLTwitterSearchStateFailed;
//        }
//        else
//        {
//            self.searchState = UYLTwitterSearchStateNotFound;
//        }
    }
    [self performSegueWithIdentifier:@"toTwitter" sender:self];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(selectedCell == self.twitterSearchCell){
        [self searchTwitter];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toTwitter"]){
        GGPTwitterResultsViewController *destination = segue.destinationViewController;
        destination.results = self.results;
    }

}
@end
