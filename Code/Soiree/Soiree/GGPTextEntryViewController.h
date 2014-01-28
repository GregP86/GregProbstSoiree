//
//  GGPTextEntryViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/28/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPTextEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textField;

- (IBAction)submitButton:(id)sender;


@end
