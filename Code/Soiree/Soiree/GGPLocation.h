//
//  GGPLocation.h
//  Soiree
//
//  Created by Greg Probst on 1/13/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GGPLocation : NSObject

@property double latitude;
@property double longitude;

@property (nonatomic, weak) NSString *locationName;
@property (nonatomic, weak) NSString *streetAddress;
@property (nonatomic, weak) NSString *city;
@property (nonatomic, weak) NSString *state;
@property (nonatomic, weak) NSString *zip;

-(PFObject *)getDBReadyObject;

@end
