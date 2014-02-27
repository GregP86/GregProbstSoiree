//
//  GGPSlideshowOptions.m
//  Soiree
//
//  Created by Greg Probst on 2/17/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPSlideshowOptions.h"

@implementation GGPSlideshowOptions

- (id)init
{
    self = [super init];
    if (self) {
        self.song = nil;
        self.frames = 5;
        self.useFade = YES;
        self.usePhotos = YES;
        self.useText = YES;
        self.useVideo = YES;
        self.useStats = YES;
        self.useWordCloud = YES;
    }
    return self;
}




@end
