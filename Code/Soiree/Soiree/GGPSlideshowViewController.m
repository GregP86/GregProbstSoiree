//
//  GGPSlideshowViewController.m
//  Soiree
//
//  Created by Greg Probst on 2/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPSlideshowViewController.h"

@interface GGPSlideshowViewController (){
    int count;
    NSTimer *timer;
}

@end

@implementation GGPSlideshowViewController

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
    count = 0;
 
    timer = [NSTimer timerWithTimeInterval:4.0
                                    target:self
                                  selector:@selector(onTimer)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)onTimer{
    [UIView animateWithDuration:3.0 animations:^{
        self.imageView.alpha = 0.0;
    }];
    
    GGPLogEntry *log = [self.logs objectAtIndex:count];
    if ([log.fileType isEqualToString:@"TXT"]) {
        self.imageView.image = nil;
        self.mainLabel.text = log.text;
        
    }else if ([log.fileType isEqualToString:@"JPEG"]){
        self.mainLabel.text = @"";
        self.imageView.image = [UIImage imageWithData:log.file];
    }else{
        self.mainLabel.text = @"";
        NSString *movieData = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.m4v"];
        NSURL *movie = [NSURL fileURLWithPath:movieData];
        GGPLogEntry *entry = log;
        self.imageView.image = nil;
        [entry.file writeToURL:movie atomically:NO];
        
        self.moviePlayer =[[MPMoviePlayerController alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];
        
        self.moviePlayer.movieSourceType = MPMovieMediaTypeMaskAudio;
        self.moviePlayer.contentURL = movie;
        self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
        self.moviePlayer.shouldAutoplay = YES;
        [self.view addSubview: [self.moviePlayer view]];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    count++;
    if(count >= self.logs.count){
        count = 0;
    }
    [UIView animateWithDuration:1.0 animations:^{
        self.imageView.alpha = 1.0;
    }];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [timer invalidate];
}
@end
