//
//  GGPEvent.m
//  Soiree
//
//  Created by Greg Probst on 1/10/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPEvent.h"

@implementation GGPEvent

-(void)createOrUpdateOnDB{
    NSNull *null = [NSNull null];
    PFObject *Event = [PFObject objectWithClassName:@"Event"];
    Event[@"Title"] = self.eventTitle;
    Event[@"Description"] = self.eventDescription;
    Event[@"StartTime"] = self.startTime;
    Event[@"EndTime"] = self.endTime;
    Event[@"Creator"] = self.creator;
    Event[@"Location"] = !self.location ? null: self.location;
    Event[@"Password"] = !self.password ? null: self.password;
    Event[@"Attendees"] = !self.Attendees ? [[NSMutableArray alloc]init]: self.Attendees;
    Event[@"Log"] = !self.eventLog ? [[NSMutableArray alloc]init]: self.eventLog;
    
    [Event saveInBackground];
}

-(void)addAttendee:(NSString *)username{
    [self.Attendees addObject:username];
    [self createOrUpdateOnDB];
}

-(void)addLogEntry:(PFObject *)entry{
    [self.eventLog addObject:entry];
    [self createOrUpdateOnDB];
}

+(GGPEvent *)restoreFromDB:(PFObject *)dbObject{
    GGPEvent *newevent = [[GGPEvent alloc] init];
    PFObject *pflocation = dbObject[@"Location"];
    
    [pflocation fetch];
    
    GGPLocation *location = [[GGPLocation alloc]init];
    PFGeoPoint *coords = [pflocation objectForKey: @"Coords"];
    location.latitude = coords.latitude;
    location.longitude = coords.longitude;
    location.locationName = pflocation[@"Name"];
    location.streetAddress = pflocation[@"Street"];
    location.city = pflocation[@"City"];
    location.state = pflocation[@"State"];
    location.zip = pflocation[@"Zip"];
    
    newevent.eventTitle = dbObject[@"Title"];
    newevent.eventDescription = dbObject[@"Description"];
    newevent.startTime = dbObject[@"StartTime"];
    newevent.endTime = dbObject[@"EndTime"];
    newevent.password = dbObject[@"Password"];
    newevent.creator = dbObject[@"Creator"];
    newevent.Attendees = dbObject[@"Attendees"];
    newevent.idString= [dbObject objectId];
    newevent.realLocation = location;

    
    
    return newevent;
}



@end
