//
//  GGPLabelConverter.m
//  Soiree
//
//  Created by Greg Probst on 2/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLabelConverter.h"

@implementation GGPLabelConverter

+(UIImage *)labelToUIImage:(UILabel *)label withView:(UIViewController *)view{

    UIGraphicsBeginImageContext([view.view bounds].size);

    [[view.view layer] renderInContext: UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
