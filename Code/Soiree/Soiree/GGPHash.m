//
//  GGPHash.m
//  Soiree
//
//  Created by Greg Probst on 3/13/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPHash.h"

@implementation GGPHash

+ (NSString *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    return [out description];
}

@end
