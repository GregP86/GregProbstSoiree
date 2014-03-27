//
//  GGPVideoEntryViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPVideoEntryViewController.h"

@interface GGPVideoEntryViewController (){
    BOOL submitPress;
    BOOL vidSelected;
}

@end

@implementation GGPVideoEntryViewController

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
    submitPress = NO;
	// Do any additional setup after loading the view.
    self.videoThumbnailView.layer.cornerRadius = 5;
    if([self.event[@"useVideo"] isEqual: @0]){
        [self.submit setTitle:@"Video Disabled" forState:UIControlStateNormal];
        [self.submit setUserInteractionEnabled:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if([self.event[@"useVideo"] isEqual: @0]){
        [self.submit setTitle:@"Video Disabled" forState:UIControlStateNormal];
        [self.submit setUserInteractionEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectVideo:(id)sender {
    self.videoSelector = [[UIImagePickerController alloc]init];
    self.videoSelector.delegate = self;
    self.videoSelector.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.videoSelector.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeMovie, nil];
    self.videoSelector.videoQuality = UIImagePickerControllerQualityTypeMedium;
    self.videoSelector.allowsEditing = NO;
    [self presentViewController:self.videoSelector animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSURL *movieURL = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.moviePlayer =[[MPMoviePlayerController alloc] initWithContentURL: movieURL];
    
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:movieURL options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time = CMTimeMake(1, 65);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    
    self.videoThumbnailView.image = [[UIImage alloc] initWithCGImage:refImg];
    vidSelected = YES;
}

- (IBAction)previewVideo:(id)sender {
    if (vidSelected) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];
        
        self.moviePlayer.movieSourceType = MPMovieMediaTypeMaskAudio;
        self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
        self.moviePlayer.shouldAutoplay = YES;
        [self.view addSubview: [self.moviePlayer view]];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}


- (IBAction)submitButton:(id)sender {
    if (vidSelected) {
        [self.indicator startAnimating];
        [self performSelector:@selector(vidSubmit) withObject:nil afterDelay:0.1];
    }else{
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No Video Selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [view show];
    }
    
}

-(void)vidSubmit{
    submitPress = YES;
    NSData *data = [NSData dataWithContentsOfURL:self.moviePlayer.contentURL];
    if([data length] < 10485760){
        self.entry = [[GGPLogEntry alloc]init];
        self.entry.file = data;
        self.entry.fileType = @"MOV";
        self.entry.isIncluded = YES;
        self.entry.submittedBy = [PFUser currentUser].username;
        self.entry.eventID = [self.event objectId];
        
        PFObject *dbEntry = [self.entry getDBReadyObject];
        [dbEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.event addObject:[dbEntry objectId] forKey:@"Log"];
                [self.event saveInBackground];
                [self performSegueWithIdentifier:@"backToLog" sender:self];
                [self.indicator stopAnimating];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"backToLog"] && submitPress && [self.source isEqualToString:@"Log"]) {
        GGPEventLogViewController *destination = [segue destinationViewController];
        destination.load = YES;
    }
}

@end
