//
//  GGPLogModeViewController.m
//  Soiree
//
//  Created by Greg Probst on 3/5/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLogModeViewController.h"

@interface GGPLogModeViewController ()

@end

@implementation GGPLogModeViewController

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
    
    [self.UIImageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoOrVideo:(id)sender {
    self.videoSelector = [[UIImagePickerController alloc]init];
    self.videoSelector.delegate = self;
    self.videoSelector.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.videoSelector.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    self.videoSelector.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, kUTTypeImage, nil];
    self.videoSelector.allowsEditing = NO;
    [self presentViewController:self.videoSelector animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString: (NSString *)kUTTypeMovie]){
        NSURL *movieURL = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        self.movData = [NSData dataWithContentsOfURL:movieURL];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:movieURL options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 65);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        self.UIImageView.image = [[UIImage alloc] initWithCGImage:refImg];
        self.UIImageView.center = CGPointMake(100.0, 100.0);
        
        self.UIImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        self.UIImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)submit:(id)sender {
    self.entry = [[GGPLogEntry alloc]init];
    if(self.movData != nil){
        self.entry.file = self.movData;
        self.entry.fileType = @"MOV";
        self.entry.isIncluded = YES;
        self.entry.submittedBy = [PFUser currentUser].username;
    }
}
@end
