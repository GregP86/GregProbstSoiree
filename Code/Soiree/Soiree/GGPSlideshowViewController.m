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
    long top;
    NSTimer *timer;
    GGPStats *stats;
    BOOL shown;
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
    top = self.logs.count;
    if (self.options.useWordCloud) {
        top++;
    }
    if (self.options.useStats) {
        top++;
    }
    shown = NO;
    stats = [[GGPStats alloc]initWithEvent:self.event];
    self.totalLabel.text =  [NSString stringWithFormat:@"%d",stats.totalCount];
    self.totalWomen.text = [NSString stringWithFormat:@"%d",stats.femaleCount];
    self.totalMen.text = [NSString stringWithFormat:@"%d",stats.maleCount];
    self.ratioLabel.text = [NSString stringWithFormat:@"%@",[stats ratioMaleToFemale]];
    self.underEighteen.text = [NSString stringWithFormat:@"%.02f%%",[stats percentUnderEighteen]];
    self.toTwentyfive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentEighteenToTwentyfive]];
    self.toThirtyFive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentTwentyfiveToThirtyfive]];
    self.toFourtyfive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentThirtyfiveToFourtyFive]];
    self.toFiftyfive.text = [NSString stringWithFormat:@"%.02f%%",[stats percentFourtyfiveToFiftyfive]];
    self.aboveFiftyFive.text = [NSString stringWithFormat:@"%.02f%%", [stats percentGreaterThanFiftyFive]];
    self.webView.layer.cornerRadius = 5;
    [self.webView setClipsToBounds:YES];
    self.webView.layer.borderColor = [[UIColor blackColor]CGColor];
    self.webView.layer.borderWidth = 2;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[GGPWordCloudRetriever getWordCloudUrlWithLogs:self.logs]];
    [self.webView loadRequest:requestObj];
    
    self.webView.alpha = 0;
    self.statsView.alpha = 0;
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    [self.player setQueueWithItemCollection:self.options.song];
    [self.player play];
    
    self.options = self.options? self.options : [[GGPSlideshowOptions alloc]init];
    
    count = 0;
 
    timer = [NSTimer timerWithTimeInterval:self.options.frames
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
    NSLog(@"fire");
    //[_moviePlayer.view removeFromSuperview];
    self.webView.alpha = 0;
    self.statsView.alpha = 0;
    GGPLogEntry *log = count < self.logs.count?[self.logs objectAtIndex:count]:[NSNull null];
    BOOL isValidType = false;
    while (!isValidType) {
        if([log isEqual:[NSNull null]]){
            if(self.options.useStats || self.options.useWordCloud){
                isValidType = true;
            }else{
                [self countUp];
            }
        }else if([log.fileType isEqualToString:@"JPEG"]){
            if (self.options.usePhotos){
                isValidType = true;
            }else{
                [self countUp];
            }
        }else if ([log.fileType isEqualToString:@"TXT"] ){
            if (self.options.useText) {
                isValidType = true;
            }else{
                [self countUp];
            }
        }else{
            if (self.options.useVideo) {
                isValidType = true;
            }else{
                [self countUp];
            }
        }
        
        log = count < self.logs.count?[self.logs objectAtIndex:count]:[NSNull null];
    }
    
    if(self.options.useFade){
        [UIView animateWithDuration:3.0 animations:^{
            self.imageView.alpha = 0.0;
            self.statsView.alpha = 0;
        }];
    }
    
    if ([log isEqual: [NSNull null]] && self.options.useStats && !shown) {
        self.imageView.image = nil;
        self.mainLabel.text = @"";
        self.statsView.alpha = 1;
        shown = YES;
    }else if([log isEqual: [NSNull null]] && self.options.useWordCloud){
        self.webView.alpha = 1;
        [self.view bringSubviewToFront:self.webView];
    }else if([log.fileType isEqualToString:@"TXT"] && self.options.useText){
            self.imageView.image = nil;
            self.mainLabel.text = log.text;
    }else if ([log.fileType isEqualToString:@"JPEG"] && self.options.usePhotos){
        self.mainLabel.text = @"";
        self.imageView.image = [UIImage imageWithData:log.file];
    }else if(self.options.useVideo){
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidStart:)
                                                     name:MPMoviePlayerDidEnterFullscreenNotification
                                                   object:self.moviePlayer];
        
        self.moviePlayer.movieSourceType = MPMovieMediaTypeMaskAudio;
        self.moviePlayer.contentURL = movie;
        self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
        self.moviePlayer.shouldAutoplay = YES;
        [self.view addSubview: [self.moviePlayer view]];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }

    [self countUp];
    if(self.options.useFade){
        [UIView animateWithDuration:1.0 animations:^{
            self.imageView.alpha = 1.0;
        }];
    }
    if (!timer.isValid) {
        [timer fire];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        timer = [NSTimer timerWithTimeInterval:self.options.frames
                                        target:self
                                      selector:@selector(onTimer)
                                      userInfo:nil
                                       repeats:YES];

    }
    
}

-(void)countUp{
    count++;
    if (count >= top) {
//        if(self.options.useStats){
//            self.statsView.alpha = 1;
//        }
        count = 0;
        shown = NO;
    }
}
- (void) moviePlayBackDidStart:(NSNotification*)notification{
    if (self.moviePlayer.duration > self.options.frames) {
        [timer invalidate];
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
    
    if (!timer.isValid) {
        timer = [NSTimer timerWithTimeInterval:self.options.frames
                                target:self
                              selector:@selector(onTimer)
                              userInfo:nil
                               repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [timer invalidate];
    [self.player stop];
}
@end
