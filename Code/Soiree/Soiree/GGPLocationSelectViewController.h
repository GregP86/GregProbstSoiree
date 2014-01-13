//
//  GGPLocationSelectViewController.h
//  Soiree
//
//  Created by Greg Probst on 1/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GGPLocationSelectViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *map;
- (IBAction)myLocation:(id)sender;

@end
