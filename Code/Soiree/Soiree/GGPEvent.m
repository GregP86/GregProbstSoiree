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
    Event[@"Attendees"] = !self.Attendees ? null: self.Attendees;
    
    [Event saveInBackground];

}

@end
