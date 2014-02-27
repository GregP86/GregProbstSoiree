//
//  GGPWordCloudRetriever.m
//  Soiree
//
//  Created by Greg Probst on 2/25/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPWordCloudRetriever.h"

@implementation GGPWordCloudRetriever

+ (NSURL *) getWordCloudUrl: (PFObject *)event{
    NSString *block = [self createWordBlock: event];
    NSDictionary *json = [self JSONRequest:block];
    NSURL *url = [NSURL URLWithString:json[@"url"]];
    return  url;
}


+ (NSString *)createWordBlock: (PFObject *)event{
    
    NSString *block = [[NSString alloc]init];
    NSMutableArray *dbobjects = event[@"Log"];
    for(NSString *s in dbobjects){
        PFQuery *query = [PFQuery queryWithClassName:@"LogEntry"];
        PFObject *object = [query getObjectWithId:s];
        NSString *string = object[@"Text"];
        if (![string isEqual:[NSNull null]]) {
            block = [block stringByAppendingString:@" "];
            block = [block stringByAppendingString:string];
        }
        
    }
    
    return block;
}

+ (NSDictionary *) JSONRequest: (NSString*) block{
    NSDictionary* headers = @{@"X-Mashape-Authorization": @"XwBsFSJltpRz5XkhnPkPibexmnRlWgKm"};
    NSDictionary* parameters = @{@"height": @"130", @"textblock": block, @"width": @"290", @"config": @"Taco"};
    
    UNIHTTPJsonResponse *response = [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:@"https://gatheringpoint-word-cloud-maker.p.mashape.com/index.php"];
        
        [simpleRequest setHeaders:headers];
        [simpleRequest setParameters:parameters];
    }]asJson];
    
    NSDictionary *json = response.body.JSONObject;
    NSLog(@"%@", json[@"url"]);
    
    return json;
}

@end
