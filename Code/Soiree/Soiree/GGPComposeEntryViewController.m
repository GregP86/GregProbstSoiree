//
//  GGPComposeEntryViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPComposeEntryViewController.h"

@interface GGPComposeEntryViewController ()

@end

@implementation GGPComposeEntryViewController

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
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.tabBarController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickImage:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)submitButton:(id)sender {
    NSData *data =  UIImageJPEGRepresentation(self.imageView.image, 0.7);
    if([data length] < 10485760){
        
        self.entry = [[GGPLogEntry alloc]init];
        self.entry.file = data;
        self.entry.text = self.captionField.text;
        self.entry.fileType = @"JPEG";
        self.entry.isIncluded = YES;
        self.entry.submittedBy = [PFUser currentUser].username;
        
        PFObject *dbEntry = [self.entry getDBReadyObject];
        [dbEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.event addObject:[dbEntry objectId] forKey:@"Log"];
                [self.event saveInBackground];
                [self performSegueWithIdentifier:@"backToLog" sender:self];
            }
        }];
    }else{
        [self showAlertView];
    }
}

-(void)showAlertView{
    UIAlertView *tooBigAlert = [[UIAlertView alloc]initWithTitle:@"File too big." message:@"Your file must be less than 10 mb" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
    [tooBigAlert show];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.vidController = [tabBarController.viewControllers objectAtIndex:1];
    self.txtController = [tabBarController.viewControllers objectAtIndex:2];
    
    self.vidController.event = self.event;
    self.txtController.event = self.event;
}


-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
