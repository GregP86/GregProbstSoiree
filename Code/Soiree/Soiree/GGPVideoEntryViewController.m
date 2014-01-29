//
//  GGPVideoEntryViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPVideoEntryViewController.h"

@interface GGPVideoEntryViewController ()

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
	// Do any additional setup after loading the view.
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
    
}

- (IBAction)previewVideo:(id)sender {
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
    NSData *data = [NSData dataWithContentsOfURL:self.moviePlayer.contentURL];
    self.entry = [[GGPLogEntry alloc]init];
    self.entry.file = data;
    self.entry.fileType = @"MOV";
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

}

@end
