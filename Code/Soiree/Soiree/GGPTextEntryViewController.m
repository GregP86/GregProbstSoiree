//
//  GGPTextEntryViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/28/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPTextEntryViewController.h"

@interface GGPTextEntryViewController (){
    BOOL submitPress;
}

@end

@implementation GGPTextEntryViewController

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
    submitPress = NO;
    [super viewDidLoad];
    self.textField.layer.cornerRadius = 5;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButton:(id)sender {
    submitPress = YES;
    self.entry = [[GGPLogEntry alloc]init];
    self.entry.fileType = @"TXT";
    self.entry.isIncluded = YES;
    self.entry.submittedBy = [PFUser currentUser].username;
    self.entry.text = self.textField.text;
    self.entry.eventID = [self.event objectId];
    
    PFObject *dbEntry = [self.entry getDBReadyObject];
    [dbEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            [self.event addObject:[dbEntry objectId] forKey:@"Log"];
            [self.event saveInBackground];
            [self performSegueWithIdentifier:@"backToLog" sender:self];
        }
    }];
}

-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"backToLog"] && submitPress) {
        GGPEventLogViewController *destination = [segue destinationViewController];
        destination.load = YES;
    }
}
@end
