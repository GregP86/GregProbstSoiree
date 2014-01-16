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

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;


-(PFObject *)getDBReadyObject;

@end
