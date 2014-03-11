//
//  GGPWordCloudRetriever.h
//  Soiree
//
//  Created by Greg Probst on 2/25/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "UNIRest.h"
#import "UNIBaseRequest.h"
#import "UNIBodyRequest.h"
#import "UNIHTTPJsonResponse.h"
#import "UNIHTTPRequest.h"
#import "UNIHTTPRequestWithBody.h"
#import "UNIHTTPResponse.h"
#import "UNIHTTPStringResponse.h"
#import "UNIJsonNode.h"
#import "UNISimpleRequest.h"
#import "UNIUrlConnection.h"
#import "Unirest-Prefix.pch"
#import "GGPLogEntry.h"

@interface GGPWordCloudRetriever : NSObject
+ (NSURL *) getWordCloudUrl: (PFObject *)event;
+ (NSURL *) getWordCloudUrlWithLogs: (NSMutableArray *)logs;
@end
