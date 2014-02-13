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
    CGRect frame;
    int shrinkOffset, numberOfItemsPerPage, numberOfPages;
    CGAffineTransform transform;
}

@end

@implementation GGPEventLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.toolbarHidden=NO;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    transform = CGAffineTransformMake(10, 10, 10, 10, 10, 10);
    self.navigationController.toolbarHidden=NO;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playVideo)]];
    self.toolbarItems = items;
    
    numberOfItemsPerPage = 4 * 3;
    numberOfPages = 2;//ceilf((CGFloat)self.LogEntries.count / (CGFloat)numberOfItemsPerPage);
   //   self.collectionView.pagingEnabled = YES;
   // [self.collectionView setCollectionViewLayout:[[GGPCollectionLayout alloc] init]];
    shrinkOffset = 64;
    NSNull *null = [[NSNull alloc]init];
    self.dbobjects = self.event[@"Log"];
    self.LogEntries = [[NSMutableArray alloc]init];
    for(NSString *s in self.dbobjects){
        PFQuery *query = [PFQuery queryWithClassName:@"LogEntry"];
        PFObject *temp =[query getObjectWithId:s];
        GGPLogEntry *entry = [[GGPLogEntry alloc]init];
        PFFile *tempFile = temp[@"Data"]? temp[@"Data"]: null;
        if(![null isEqual:tempFile]){
            entry.file = [tempFile getData];
        }
        entry.fileType = temp[@"FileType"];
        entry.text = temp[@"Text"]? temp[@"Text"] : nil;
        entry.isIncluded = temp[@"isIncluded"];
        entry.submittedBy = temp[@"SubmittedBy"];
        [self.LogEntries addObject:entry];
    }
	
    NSLog(@"done");
    
//    UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc]init];
//    myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    [self.collectionView setCollectionViewLayout:myLayout animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEntryCompose"]){
        GGPComposeEntryViewController *vcImage = [[GGPComposeEntryViewController alloc] init];
        UITabBarController* tbc = [segue destinationViewController];
        vcImage = (GGPComposeEntryViewController*)[[tbc customizableViewControllers] objectAtIndex:0];
        
        vcImage.event = self.event;
    }else if([segue.identifier isEqualToString:@"toSlideshow"]){
        GGPSlideshowViewController *destination = [segue destinationViewController];
        destination.logs = self.LogEntries;
    }

    self.navigationController.toolbarHidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden=YES;
}

-(IBAction)toLog:(UIStoryboardSegue *)segue{
    
}

-(void)playVideo{
    
    [self performSegueWithIdentifier:@"toSlideshow" sender:self];
//    NSMutableArray *images = [[NSMutableArray alloc]init];
//    
//    
//    for (GGPLogEntry *entry in self.LogEntries) {
//        if([entry.fileType  isEqualToString: @"TXT"]){
//            UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 75, 300, 350)];
//            tempLabel.numberOfLines = 10;
//            tempLabel.text = entry.text;
//            UIImage *tempImage = [GGPLabelConverter labelToUIImage:tempLabel withView:self];
//            [images addObject:tempImage];
//        }else if([entry.fileType isEqualToString:@"JPEG"]){
//            [images addObject:entry.file];
//        }else{
//            
//        }
//    }
}
//
//-(void) writeImagesToMovieAtPath:(NSString *) path withSize:(CGSize) size withImages:(NSMutableArray *)images
//{
//    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
//    for (NSString *tString in dirContents)
//    {
//        if ([tString isEqualToString:@"essai.mp4"])
//        {
//            [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,tString] error:nil];
//            
//        }
//    }
//    
//    NSLog(@"Write Started");
//    
//    NSError *error = nil;
//    
//    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
//                                  [NSURL fileURLWithPath:path] fileType:AVFileTypeMPEG4
//                                                              error:&error];
//    NSParameterAssert(videoWriter);
//    
//    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   AVVideoCodecH264, AVVideoCodecKey,
//                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
//                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
//                                   nil];
//    
//    
//    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
//                                             assetWriterInputWithMediaType:AVMediaTypeVideo
//                                             outputSettings:videoSettings];
//    
//    
//    
//    
//    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
//                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
//                                                     sourcePixelBufferAttributes:nil];
//    
//    NSParameterAssert(videoWriterInput);
//    
//    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
//    videoWriterInput.expectsMediaDataInRealTime = YES;
//    [videoWriter addInput:videoWriterInput];
//    //Start a session:
//    [videoWriter startWriting];
//    [videoWriter startSessionAtSourceTime:kCMTimeZero];
//    
//    
//    //Video encoding
//    
//    CVPixelBufferRef buffer = NULL;
//    
//    //convert uiimage to CGImage.
//    
//    int frameCount = 0;
//    
//    for(int i = 0; i<[images count]; i++)
//    {
//        buffer = [self newPixelBufferFromCGImage:[[images objectAtIndex:i] CGImage] andSize:size] ;
//        
//        
//        BOOL append_ok = NO;
//        int j = 0;
//        while (!append_ok && j < 30)
//        {
//            if (adaptor.assetWriterInput.readyForMoreMediaData)
//            {
//                printf("appending %d attemp %d\n", frameCount, j);
//                
//                CMTime frameTime = CMTimeMake(frameCount,(int32_t) 10);
//                
//                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
//                CVPixelBufferPoolRef bufferPool = adaptor.pixelBufferPool;
//                NSParameterAssert(bufferPool != NULL);
//                
//                [NSThread sleepForTimeInterval:0.05];
//            }
//            else
//            {
//                printf("adaptor not ready %d, %d\n", frameCount, j);
//                [NSThread sleepForTimeInterval:0.1];
//            }
//            j++;
//        }
//        if (!append_ok)
//        {
//            printf("error appending image %d times %d\n", frameCount, j);
//        }
//        frameCount++;
//        CVBufferRelease(buffer);
//    }
//    
//    [videoWriterInput markAsFinished];
//    [videoWriter finishWriting];
//    
//    [m_PictArray removeAllObjects];
//    
//    NSLog(@"Write Ended"); 
//}
//
//- (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image andSize:(CGSize) size
//{
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
//                             nil];
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
//                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
//                                          &pxbuffer);
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//    
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    NSParameterAssert(pxdata != NULL);
//    
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
//                                                 size.height, 8, 4*size.width, rgbColorSpace,
//                                                 kCGImageAlphaNoneSkipFirst);
//    NSParameterAssert(context);
//    
//    CGContextConcatCTM(context, transform);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
//                                           CGImageGetHeight(image)), image);
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//    
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//    
//    return pxbuffer;
//}

#pragma mark delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return numberOfItemsPerPage * numberOfPages;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > [self.LogEntries count] -1 || [self.LogEntries count]==0) {
        //We have no more items, so return nil. This is to trick it to display actual full pages.
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:111];
        NSString *text = @" ";
        label.text = text;
        return cell;
    }
    
    long row = [indexPath row];
    GGPLogEntry *entry = [self.LogEntries objectAtIndex:row];
    UICollectionViewCell *cell;
    
    
    
    if ([entry.fileType isEqualToString:@"TXT"] ) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:111];
        NSString *text = entry.text;
        if([self.event[@"isFiltered"] isEqual:@1]){
            text = [GGPTextFilter filter:text];
        }
        label.text = [NSString stringWithFormat:@"%@ - %@", text, entry.submittedBy];
    }
    else if ([entry.fileType isEqualToString:@"JPEG"]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
        UIImageView *view = (UIImageView *)[cell viewWithTag:112];
        UILabel *label = (UILabel *)[cell viewWithTag:113];
        NSString *text = entry.text;
        if([self.event[@"isFiltered"] isEqual:@1]){
            text = [GGPTextFilter filter:text];
        }
        label.text = [NSString stringWithFormat:@"%@ - %@", text, entry.submittedBy];
        view.image = [UIImage imageWithData:entry.file];
    } else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video" forIndexPath:indexPath];
       
        
        NSString *movieData = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.m4v"];
        NSURL *movie = [NSURL fileURLWithPath:movieData];
        [entry.file writeToURL:movie atomically:NO];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:movie options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 65);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        
        UIImageView *view = (UIImageView *)[cell viewWithTag:114];
        view.image = [[UIImage alloc] initWithCGImage:refImg];
        
        UILabel *label = (UILabel *)[cell viewWithTag:115];
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
   
    
    //[self.collectionView.collectionViewLayout invalidateLayout];
    UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //[self.view convertPoint:CGPointZero fromView:[UIApplication sharedApplication].keyWindow];
    
    if ([cell.reuseIdentifier isEqualToString:@"video"]) {
        
        NSString *movieData = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.m4v"];
        NSURL *movie = [NSURL fileURLWithPath:movieData];
        GGPLogEntry *entry = self.LogEntries[indexPath.row];
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
        
        

    }else if(!largeCell){
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

-(void)enlargeCell:(UICollectionViewCell *)cell inCollectionView:(UICollectionView *)collectionView{
    [UIView animateWithDuration:.5
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell.layer setCornerRadius:10];
                         frame = [collectionView convertRect:cell.frame toView:self.view];
                         NSLog(@"animation start");
                         [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7] ];
                         cell.frame =  CGRectMake(cell.frame.origin.x - self.collectionView.contentOffset.x + cell.frame.origin.x, 75, 300, 350);
                         [self.collectionView bringSubviewToFront:cell];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"animation end");
                         
                         if([cell.reuseIdentifier isEqualToString:@"text"]){
                             [self enlargeTextCellContents:cell];
                         }else if ([cell.reuseIdentifier isEqualToString:@"image"]){
                             [self enlargeImageCellContents:cell];
                         }
                         
                     }
     ];

}

-(void)enlargeTextCellContents:(UICollectionViewCell *)cell{
    [UIView animateWithDuration:.5
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         UILabel *label = (UILabel *)[cell viewWithTag:111];
                         label.frame = CGRectMake(5, 5, 280, 330);
                         label.font = [UIFont systemFontOfSize:50];
                         label.textColor = [UIColor blackColor];
                     } completion:^(BOOL finished) {
                         
                     }];

}

-(void)enlargeImageCellContents:(UICollectionViewCell *)cell{
    [UIView animateWithDuration:.5
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         UIImageView *view = (UIImageView *)[cell viewWithTag:112];
                         view.frame = CGRectMake(7, 5, 285, 340);
                         UILabel *label = (UILabel *)[cell viewWithTag:113];
                         label.frame = CGRectMake(5, 280, 285, 100);
                         label.font = [UIFont systemFontOfSize:25];
                         label.textColor = [UIColor blackColor];
                         view.contentMode = UIViewContentModeScaleAspectFit;
                     } completion:^(BOOL finished) {
                         
                     }];

}

-(void)shrinkCell:(UICollectionViewCell *)cell inCollectionView:(UICollectionView *)collectionView{
    CGRect tempFrame = frame;
    if([cell.reuseIdentifier isEqualToString:@"text"]){
        [self shrinkTextCellContents:cell toSize: tempFrame];
    }else if ([cell.reuseIdentifier isEqualToString:@"image"]){
        [self shrinkImageCellContents:cell toSize:tempFrame];
    }
    
    
}


-(void)shrinkTextCellContents:(UICollectionViewCell *)cell toSize:(CGRect)tempFrame{
    [UIView animateWithDuration:.5
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         UILabel *label = (UILabel *)[cell viewWithTag:111];
                         label.frame = CGRectMake(0, 0, 100, 100);
                         label.font = [UIFont systemFontOfSize:12];
                         label.textColor = [UIColor whiteColor];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.5
                                               delay:0
                                             options:(UIViewAnimationOptionAllowUserInteraction)
                                          animations:^{
                                              NSLog(@"animation start");
                                              [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7]];
                                              cell.frame = CGRectMake(tempFrame.origin.x, (tempFrame.origin.y - shrinkOffset), 100, 100);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"animation end");
                                              [cell setBackgroundColor:[UIColor blackColor]];
                                              [cell.layer setCornerRadius:0];
                                          }
                          ];
                     }];
    
}

-(void)shrinkImageCellContents:(UICollectionViewCell *)cell toSize:(CGRect)tempFrame{
    [UIView animateWithDuration:.5
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         UIImageView *view = (UIImageView *)[cell viewWithTag:112];
                         view.frame = CGRectMake(0, 0 , 100, 100);
                         view.contentMode = UIViewContentModeScaleAspectFit;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0
                                               delay:0
                                             options:(UIViewAnimationOptionAllowUserInteraction)
                                          animations:^{
                                              NSLog(@"animation start");
                                              [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.7] ];
                                              cell.frame = CGRectMake(tempFrame.origin.x, (tempFrame.origin.y - shrinkOffset), 100, 100);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"animation end");
                                              [cell setBackgroundColor:[UIColor blackColor]];
                                              [cell.layer setCornerRadius:0];
                                          }
                          ];

                     }];
    
}





@end
