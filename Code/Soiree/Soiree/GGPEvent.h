//
//  GGPEvent.h
//  Soiree
//
//  Created by Greg Probst on 1/10/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGPLocation.h"
#import "GGPLogEntry.h"

@interface GGPEvent : NSObject

@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) PFObject *location;
@property (nonatomic, strong) GGPLocation *realLocation;
@property (nonatomic, strong) NSMutableArray *Attendees;
@property (nonatomic, strong) NSMutableArray *eventLog;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *idString;

-(void)createOrUpdateOnDB;
-(void)addAttendee: (NSString *) username;
+(GGPEvent *)restoreFromDB:(PFObject *)dbObject;

@end
