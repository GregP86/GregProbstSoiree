//
//  GGPEvent.h
//  Soiree
//
//  Created by Greg Probst on 1/10/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGPLocation.h"

@interface GGPEvent : NSObject

@property (nonatomic, weak) NSString *creator;
@property (nonatomic, weak) NSString *eventTitle;
@property (nonatomic, weak) NSString *eventDescription;
@property (nonatomic, weak) NSDate *startTime;
@property (nonatomic, weak) NSDate *endTime;
@property (nonatomic, weak) PFObject *location;

-(void)createOrUpdateOnDB;

@end
