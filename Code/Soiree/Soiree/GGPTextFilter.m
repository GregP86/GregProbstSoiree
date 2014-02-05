//
//  GGPTextFilter.m
//  Soiree
//
//  Created by Greg Probst on 2/4/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPTextFilter.h"

@implementation GGPTextFilter

+(NSString *)filter:(NSString *)string{
    NSString *filterString = string;
    if(string){
        NSString *pattern = @"(shit|fuck|tits|cunt|sex|bastard|ass|damn|bitch|pussy)";
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        filterString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"****"];
    }
    
    return filterString;
}

@end
