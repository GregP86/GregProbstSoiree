//
//  GGPVideoEntryViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "GGPLogEntry.h"
#import <QuartzCore/QuartzCore.h>
#import "GGPEventLogViewController.h"

@interface GGPVideoEntryViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>



@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) PFObject *event;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnailView;
@property (strong, nonatomic) UIImagePickerController *videoSelector;
@property (strong, nonatomic) GGPLogEntry *entry;
@property (weak, nonatomic) IBOutlet UIButton *submit;


- (IBAction)selectVideo:(id)sender;
- (IBAction)previewVideo:(id)sender;
- (IBAction)submitButton:(id)sender;


@end
