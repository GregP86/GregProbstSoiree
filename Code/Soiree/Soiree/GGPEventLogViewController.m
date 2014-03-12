//
//  GGPEventLogViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPEventLogViewController.h"

@interface GGPEventLogViewController (){
    UICollectionViewCell *largeCell;
    UICollectionViewCell *cell;
    CGRect frame, labelRef, temp;
    int shrinkOffset, numberOfItemsPerPage, numberOfPages;
    UILabel *label;
    UIImageView *view;
    NSString *text;
    PFObject *object;
    GGPLogEntry *entry;
    PFFile *image;
    NSData *data;
    AVURLAsset *asset;
    AVAssetImageGenerator *generateImg;
    NSString *movieData;
    NSURL *movie;
    CGImageRef refImg;
    int offset;
    

}

@end

@implementation GGPEventLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.load = NO;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.toolbarHidden=NO;
    
    if (self.load) {
        [self.view bringSubviewToFront:self.activityIndicator];
        [self.activityIndicator startAnimating];
        [self performSelector:@selector(Refresh) withObject:nil afterDelay:0.1];
    }
    self.load = NO;
}

-(void)Refresh{
    self.navigationController.toolbarHidden=NO;
    [self LoadItems];
    [self.collectionView reloadData];
    [self.activityIndicator stopAnimating];
}

- (void)viewDidLoad
{
    offset = 0;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playVideo)]];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    if ([[PFUser currentUser].username isEqualToString:self.event[@"Creator"]]) {
        [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Edit Log" style:UIBarButtonItemStylePlain target:self action:@selector(logEdit)]];
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    }
    
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(slideOptions)]];
    self.toolbarItems = items;
    
    [super viewDidLoad];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.activityIndicator.color = [UIColor colorWithRed:224.0f/225.0f green:70.0f/225.0f blue:3/225.0f alpha:1];
    
    self.navigationController.toolbarHidden=NO;
    [self LoadItems];
    
    
    
//    UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc]init];
//    myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    [self.collectionView setCollectionViewLayout:myLayout animated:YES];
}

-(void)LoadItems{
    
    shrinkOffset = 64;
    self.dbobjects = self.event[@"Log"];
    self.LogEntries = [[NSMutableArray alloc]init];
    for(NSString *s in self.dbobjects){
        PFQuery *query = [PFQuery queryWithClassName:@"LogEntry"];
        object =[query getObjectWithId:s];
        entry = [GGPLogEntry objectFromDb:object];
        [self.LogEntries addObject:entry];
    }
	
    numberOfItemsPerPage = 12;
    numberOfPages = ceilf((CGFloat)self.LogEntries.count / (CGFloat)numberOfItemsPerPage);
    
    NSLog(@"done");
}

-(void)logEdit{
    [self performSegueWithIdentifier:@"toLogEdit" sender:self];  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)slideOptions{
    [self performSegueWithIdentifier:@"toSlideOptions" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEntryCompose"]){
        GGPComposeEntryViewController *vcImage = [[GGPComposeEntryViewController alloc] init];
        GGPVideoEntryViewController *vidControl = [[GGPVideoEntryViewController alloc] init];
        GGPTextEntryViewController *textControl = [[GGPTextEntryViewController alloc] init];
        UITabBarController* tbc = [segue destinationViewController];
        vcImage = (GGPComposeEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:0];
        vidControl = (GGPVideoEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:1];
        textControl = (GGPTextEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:2];
        vcImage.event = self.event;
        vidControl.event = self.event;
        textControl.event = self.event;
    }else if([segue.identifier isEqualToString:@"toSlideshow"]){
        GGPSlideshowViewController *destination = [segue destinationViewController];
        destination.logs = self.LogEntries;
        destination.options = self.options;
        destination.event = self.event;
    }else if([segue.identifier isEqualToString:@"toSlideOptions"]){
        GGPSlideShowOptionsViewController *destination = [segue destinationViewController];
        destination.options = self.options;
    }else if([segue.identifier isEqualToString:@"toLogEdit"]){
        GGPLogEditViewController *destination = [segue destinationViewController];
        destination.LogEntries = self.LogEntries;
        destination.event = self.event;
    }


    self.navigationController.toolbarHidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden=YES;
}

-(IBAction)toLog:(UIStoryboardSegue *)segue{
    
}

-(void)playVideo{
    [self.activityIndicator startAnimating];
    [self performSelector:@selector(videoSegue) withObject:nil afterDelay:0.1];
}

-(void)videoSegue{
    [self performSegueWithIdentifier:@"toSlideshow" sender:self];
}

#pragma mark delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return numberOfItemsPerPage * numberOfPages;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > [self.LogEntries count] -1 || [self.LogEntries count]==0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
        label = (UILabel *)[cell viewWithTag:111];
        text = @" ";
        label.text = text;
        return cell;
    }
    
    long row = [indexPath row];
    entry = [self.LogEntries objectAtIndex:row];
    
    
    
    if ([entry.fileType isEqualToString:@"TXT"] ) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
        label = (UILabel *)[cell viewWithTag:111];
        text = entry.text;
        if([self.event[@"isFiltered"] isEqual:@1]){
            text = [GGPTextFilter filter:text];
        }
        label.text = [NSString stringWithFormat:@"%@ - %@", text, entry.submittedBy];
    }
    else if ([entry.fileType isEqualToString:@"JPEG"]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
        view = (UIImageView *)[cell viewWithTag:112];
        label = (UILabel *)[cell viewWithTag:113];
        text = entry.text;
        if([self.event[@"isFiltered"] isEqual:@1]){
            text = [GGPTextFilter filter:text];
        }
        label.text = [NSString stringWithFormat:@"%@ - %@", text, entry.submittedBy];
        data = entry.file;
        view.image = [UIImage imageWithData:data];
    } else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
        data = entry.file;
        
        movieData = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.m4v"];
        movie = [NSURL fileURLWithPath:movieData];
        [data writeToURL:movie atomically:NO];
        
        asset = [[AVURLAsset alloc] initWithURL:movie options:nil];
        generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 65);
        refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        
        view = (UIImageView *)[cell viewWithTag:114];
        view.image = [[UIImage alloc] initWithCGImage:refImg];
        
        label = (UILabel *)[cell viewWithTag:115];
        label.text = [NSString stringWithFormat:@"video - %@", entry.submittedBy];
        
    }
    
    return cell;
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    long num = indexPath.row;
    //[self.collectionView.collectionViewLayout invalidateLayout];
    cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //[self.view convertPoint:CGPointZero fromView:[UIApplication sharedApplication].keyWindow];
    
    if ([cell.reuseIdentifier isEqualToString:@"video"]) {
        
        movieData = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.m4v"];
        movie = [NSURL fileURLWithPath:movieData];
        entry = self.LogEntries[indexPath.row];
        data = entry.file;
        [data writeToURL:movie atomically:NO];
        
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
        
        

    }else if(!largeCell){
        if (num >= 12) {
            offset = 320;
        }else{
            offset = 0;
        }
        frame = [collectionView convertRect:cell.frame toView:self.view];
        [self enlargeCell:cell inCollectionView:collectionView];
        largeCell = cell;
    }else if ([cell isEqual:largeCell]){
        [self shrinkCell:largeCell inCollectionView:collectionView];
        largeCell = nil;
    }else{
        [self shrinkCell:largeCell inCollectionView:collectionView];
        
        
        [self enlargeCell:cell inCollectionView:collectionView];
        largeCell = cell;
    }
    
    
}

-(void)enlargeCell:(UICollectionViewCell *)cellY inCollectionView:(UICollectionView *)collectionView{
    [UIView animateWithDuration:.25
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cellY.layer setCornerRadius:10];
                         frame = [collectionView convertRect:cellY.frame toView:self.view];
                         NSLog(@"animation start");
                         [cellY setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.7] ];
                         cellY.frame =  CGRectMake((10 + offset), 75, 300, 350);
                         [self.collectionView bringSubviewToFront:cellY];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"animation end");
                         
                         if([cellY.reuseIdentifier isEqualToString:@"text"]){
                             [self enlargeTextCellContents:cellY];
                         }else if ([cell.reuseIdentifier isEqualToString:@"image"]){
                             [self enlargeImageCellContents:cellY];
                         }
                         
                     }
     ];

}

-(void)enlargeTextCellContents:(UICollectionViewCell *)cellY{
    [UIView animateWithDuration:.25
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         label = (UILabel *)[cellY viewWithTag:111];
                         label.frame = CGRectMake(5, 5, 280, 330);
                         label.font = [UIFont systemFontOfSize:50];
                         label.textColor = [UIColor whiteColor];
                     } completion:^(BOOL finished) {
                         
                     }];

}

-(void)enlargeImageCellContents:(UICollectionViewCell *)cellY{

    [UIView animateWithDuration:.25
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         view = (UIImageView *)[cellY viewWithTag:112];
                         view.frame = CGRectMake(7, 5, 285, 340);
                         label = (UILabel *)[cellY viewWithTag:113];
                         temp = label.frame;
                         label.frame = CGRectMake(5, 235, 285, 100);
                         label.font = [UIFont systemFontOfSize:25];
                         label.textColor = [UIColor whiteColor];
                         view.contentMode = UIViewContentModeScaleAspectFit;
                     } completion:^(BOOL finished) {
                         labelRef = temp;
                     }];

}

-(void)shrinkCell:(UICollectionViewCell *)cellY inCollectionView:(UICollectionView *)collectionView{
    CGRect tempFrame = frame;
    if([cellY.reuseIdentifier isEqualToString:@"text"]){
        [self shrinkTextCellContents:cellY toSize: tempFrame];
    }else if ([cellY.reuseIdentifier isEqualToString:@"image"]){
        [self shrinkImageCellContents:cellY toSize:tempFrame];
    }
    
    
}


-(void)shrinkTextCellContents:(UICollectionViewCell *)cellY toSize:(CGRect)tempFrame{
    [UIView animateWithDuration:.25
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         label = (UILabel *)[cellY viewWithTag:111];
                         label.frame = CGRectMake(0, 0, 100, 100);
                         label.font = [UIFont systemFontOfSize:12];
                         label.textColor = [UIColor blackColor];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.25
                                               delay:0
                                             options:(UIViewAnimationOptionAllowUserInteraction)
                                          animations:^{
                                              NSLog(@"animation start");
                                              [cellY setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7]];
                                              cellY.frame = CGRectMake(tempFrame.origin.x + offset, (tempFrame.origin.y - shrinkOffset), 100, 100);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"animation end");
                                              [cellY setBackgroundColor:[UIColor whiteColor]];
                                              [cellY.layer setCornerRadius:0];
                                          }
                          ];
                     }];
    
}

-(void)shrinkImageCellContents:(UICollectionViewCell *)cellY toSize:(CGRect)tempFrame{
    [UIView animateWithDuration:.25
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         view = (UIImageView *)[cellY viewWithTag:112];
                         view.frame = CGRectMake(0, 0 , 100, 100);
                         label.frame = labelRef;
                         label.font = [UIFont systemFontOfSize:12];
                         view.contentMode = UIViewContentModeScaleAspectFit;
                         label.textColor = [UIColor blackColor];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.25
                                               delay:0
                                             options:(UIViewAnimationOptionAllowUserInteraction)
                                          animations:^{
                                              NSLog(@"animation start");
                                              [cellY setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7] ];
                                              cellY.frame = CGRectMake(tempFrame.origin.x + offset, (tempFrame.origin.y - shrinkOffset), 100, 100);
                                              label = (UILabel *)[cellY viewWithTag:113];
                                              
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"animation end");
                                              [cellY setBackgroundColor:[UIColor whiteColor]];
                                              [cellY.layer setCornerRadius:0];
                                          }
                          ];

                     }];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [self.activityIndicator stopAnimating];
}


@end
