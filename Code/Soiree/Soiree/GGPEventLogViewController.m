//
//  GGPEventLogViewController.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPEventLogViewController.h"

@interface GGPEventLogViewController ()

@end

@implementation GGPEventLogViewController

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
    }

}

-(IBAction)toLog:(UIStoryboardSegue *)segue{
    
}

#pragma mark delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.LogEntries count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    long row = [indexPath row];
    GGPLogEntry *entry = [self.LogEntries objectAtIndex:row];
    UICollectionViewCell *cell;
    
    if ([entry.fileType isEqualToString:@"TXT"] ) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:111];
        label.text = [NSString stringWithFormat:@"%@ - %@", entry.text, entry.submittedBy];
    }
    else if ([entry.fileType isEqualToString:@"JPEG"]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
        UIImageView *view = (UIImageView *)[cell viewWithTag:112];
        UILabel *label = (UILabel *)[cell viewWithTag:113];
        label.text = [NSString stringWithFormat:@"%@ - %@", entry.text, entry.submittedBy];
        view.image = [UIImage imageWithData:entry.file];
    }else{
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

@end
