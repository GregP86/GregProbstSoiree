//
//  GGPSlideshowOptions.h
//  Soiree
//
//  Created by Greg Probst on 2/17/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GGPSlideshowOptions : NSObject

@property(strong, nonatomic) MPMediaItemCollection *song;
@property(nonatomic) int frames;
@property(nonatomic) BOOL useFade;
@property(nonatomic) BOOL usePhotos;
@property(nonatomic) BOOL useText;
@property(nonatomic) BOOL useVideo;
-(void)showPicker: (UIViewController *)sender;

@end
