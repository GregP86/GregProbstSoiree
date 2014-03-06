//
//  GGPLogModeViewController.h
//  Soiree
//
//  Created by Greg Probst on 3/5/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPLogEntry.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface GGPLogModeViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *UIImageView;
- (IBAction)takePhotoOrVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) UIImagePickerController *videoSelector;
@property (strong, nonatomic) GGPLogEntry *entry;
@property (strong, nonatomic) NSData *movData;
@property (strong, nonatomic) UIImage *submitMovie;
- (IBAction)submit:(id)sender;

@end
