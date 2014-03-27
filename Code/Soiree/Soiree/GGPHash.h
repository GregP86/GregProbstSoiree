//
//  GGPHash.h
//  Soiree
//
//  Created by Greg Probst on 3/13/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>

@interface GGPHash : NSObject

+ (NSString *) createSHA512:(NSString *)source;

@end
