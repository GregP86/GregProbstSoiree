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
    self.imageView.layer.cornerRadius = 5;
    self.captionField.layer.cornerRadius = 5;
    if([self.event[@"usePhoto"] isEqual: @0]){
       [self.submit setTitle:@"Photo Disabled" forState:UIControlStateNormal];
        [self.submit setUserInteractionEnabled:NO];
    }else{
        [self.submit setTitle:@"Submit Photo" forState:UIControlStateNormal];
        [self.submit setUserInteractionEnabled:YES];
    }

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
    self.imageView.image = [self imageWithImage:self.imageView.image scaledToSize:CGSizeMake(self.imageView.image.size.width/10, self.imageView.image.size.height/10)];
    NSData *data =  UIImageJPEGRepresentation(self.imageView.image, 0.5);
    if([data length] < 10485760){
        
        self.entry = [[GGPLogEntry alloc]init];
        self.entry.file = data;
        self.entry.text = self.captionField.text;
        self.entry.fileType = @"JPEG";
        self.entry.isIncluded = YES;
        self.entry.submittedBy = [PFUser currentUser].username;
        self.entry.eventID = [self.event objectId];
        
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

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    self.vidController = [tabBarController.viewControllers objectAtIndex:1];
//    self.txtController = [tabBarController.viewControllers objectAtIndex:2];
//    
//    self.vidController.event = self.event;
//    self.txtController.event = self.event;
//}


-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIButton *button = sender;
    if ([segue.identifier isEqualToString:@"backToLog"] && [button isEqual:self.submit]) {
        GGPEventLogViewController *destination = [segue destinationViewController];
        destination.load = YES;
    }
}

@end
