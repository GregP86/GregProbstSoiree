//
//  GGPLogModeViewController.h
//  Soiree
//
//  Created by Greg Probst on 3/5/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPLogModeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *UIImageView;
- (IBAction)takePhotoOrVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submit:(id)sender;

@end
