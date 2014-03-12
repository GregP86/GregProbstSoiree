//
//  GGPLogEntry.m
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLogEntry.h"

@implementation GGPLogEntry


-(PFObject *)getDBReadyObject{
    NSNull *null = [[NSNull alloc]init];
    PFObject *entry = [PFObject objectWithClassName:@"LogEntry"];
    PFFile *file = self.file ? [PFFile fileWithName:self.fileName data:self.file]: nil;
    entry[@"Data"] = file? file : null;
    entry[@"Text"] = self.text? self.text: null;
    entry[@"isIncluded"] = self.isIncluded ? @1: @0;
    entry[@"FileType"] = self.fileType;
    entry[@"SubmittedBy"] = self.submittedBy;
    entry[@"eventID"] = self.eventID;
    
    return entry;
}

+(GGPLogEntry *)objectFromDb:(PFObject *)dbObject{
    GGPLogEntry *entry = [[GGPLogEntry alloc]init];
    PFFile *file = dbObject[@"Data"];
    entry.file = [file isEqual:[NSNull null]]? nil : [file getData];
    entry.text = dbObject[@"Text"];
    entry.fileType = dbObject[@"FileType"];
    entry.submittedBy = dbObject[@"SubmittedBy"];
    entry.eventID = dbObject[@"eventID"];
    entry.id = [dbObject objectId];
    
    return entry;
}
@end
