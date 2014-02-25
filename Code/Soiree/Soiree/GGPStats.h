//
//  GGPStats.h
//  Soiree
//
//  Created by Greg Probst on 2/24/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GGPStats : NSObject

@property (strong, nonatomic) PFObject *event;
@property int totalCount;
@property int maleCount;
@property int femaleCount;

@property int underEighteen;
@property int eighteenToTwentyFive;
@property int twentyFiveToThirtyFive;
@property int thirtyFiveToFourtyFive;
@property int fourtyFiveToFiftyFive;
@property int greaterThan55;

-(int)GCD:(int) first and:(int) second;
- (id)initWithEvent:(PFObject *)event;
-(NSString *)ratioMaleToFemale;

@end
