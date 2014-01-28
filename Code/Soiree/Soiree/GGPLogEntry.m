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
    PFObject *entry = [PFObject objectWithClassName:@"LogEntry"];
    PFFile *file = [PFFile fileWithName:self.fileName data:self.file];
    NSNull *null = [[NSNull alloc]init];
    entry[@"Data"] = file;
    entry[@"Text"] = self.text? self.text: null;
    entry[@"isIncluded"] = self.isIncluded ? @1: @0;
    entry[@"FileType"] = self.fileType;
    entry[@"SubmittedBy"] = self.submittedBy;
    
    return entry;
}

@end
