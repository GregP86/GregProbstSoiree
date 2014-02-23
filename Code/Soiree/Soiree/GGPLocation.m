//
//  GGPLocation.m
//  Soiree
//
//  Created by Greg Probst on 1/13/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPLocation.h"

@implementation GGPLocation
//
-(PFObject *)getDBReadyObject{
    PFObject *location = [PFObject objectWithClassName:@"Location"];
    location[@"Name"] = self.locationName;
    location[@"Street"] = self.streetAddress;
    location[@"City"] = self.city;
    location[@"State"] = self.state;
    location[@"Zip"] = self.zip;
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    location[@"Coords"] = geoPoint;
    
    return location;
}

@end
