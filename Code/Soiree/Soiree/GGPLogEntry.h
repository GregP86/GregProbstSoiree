//
//  GGPLogEntry.h
//  Soiree
//
//  Created by Greg Probst on 1/22/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GGPLogEntry : NSObject

@property (strong, nonatomic) NSData *file;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileType;
@property (strong, nonatomic) NSString *submittedBy;
@property (strong, nonatomic) NSString *id;
@property (nonatomic) BOOL isIncluded;

-(PFObject *)getDBReadyObject;

@end
