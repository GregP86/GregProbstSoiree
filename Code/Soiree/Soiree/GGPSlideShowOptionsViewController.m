//
//  GGPSlideShowOptionsViewController.m
//  Soiree
//
//  Created by Greg Probst on 2/14/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPSlideShowOptionsViewController.h"

@interface GGPSlideShowOptionsViewController ()

@end

@implementation GGPSlideShowOptionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.picker = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
    self.options = [[GGPSlideshowOptions alloc]init];
    self.picker.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slider:(id)sender {
    int count = self.frameSlider.value;
    self.secondsLabel.text = [NSString stringWithFormat: @"%d", count];
    self.options.frames = count;
}

- (IBAction)fadeTrasitionSwitch:(id)sender {
    self.options.useFade = !self.options.useFade;
}

- (IBAction)includePhotoSwitch:(id)sender {
    self.options.usePhotos = !self.options.usePhotos;
}

- (IBAction)includeText:(id)sender {
    self.options.useText = !self.options.useText;
}

- (IBAction)inludeVideoSwitch:(id)sender {
    self.options.useVideo = !self.options.useVideo;
}

-(void)showPicker{
    self.picker.allowsPickingMultipleItems = NO;
    self.picker.prompt = @"Select any song.";
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    [self dismissViewControllerAnimated:YES completion:nil];
    MPMediaItem *song = mediaItemCollection.items[0];
    self.options.song = mediaItemCollection;
    NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
    self.selectedSongLabel.text = title;
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self showPicker];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"getBack"]){
        GGPEventLogViewController *destination = [segue destinationViewController];
        destination.options = self.options;
    }
}

@end
