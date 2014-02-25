//
//  GGPStats.m
//  Soiree
//
//  Created by Greg Probst on 2/24/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPStats.h"

@implementation GGPStats

- (id)initWithEvent:(PFObject *)event{
    self = [super init];
    if (self) {
        self.event = event;
        [self loadData];
    }
    return self;
}

-(void)loadData{
    NSArray *attendees = self.event[@"Attendees"];
    for (NSString *s in attendees) {
        PFUser *user = [PFQuery getUserObjectWithId:s];
        [self genderCount:user];
        [self ageCount:user];
    }
}

-(void)genderCount: (PFUser *)user{
    self.totalCount++;
    if ([user[@"Gender"]  isEqual: @1]) {
        self.femaleCount++;
    }else{
        self.maleCount++;
    }
}

-(void)ageCount:(PFUser *)user{
    NSNumber *ageObj = user[@"age"];
    int age = [ageObj intValue];
    if (age < 18) {
        self.underEighteen++;
    }else if(age < 26){
        self.eighteenToTwentyFive++;
    }else if(age < 36){
        self.twentyFiveToThirtyFive++;
    }else if(age < 46){
        self.thirtyFiveToFourtyFive++;
    }else if(age < 56){
        self.fourtyFiveToFiftyFive++;
    }else{
        self.greaterThan55++;
    }
}

-(int)GCD:(int) first and:(int) second{
    int GCD, remain;
    
    while(first != 0){
        remain = second % first;
        second = first;
        first = remain;
    }
    
    GCD = second;
    
    return GCD;
}

-(NSString *)ratioMaleToFemale{
    int numerator = self.maleCount/[self GCD:self.maleCount and:self.femaleCount];
    int denomenator = self.femaleCount/[self GCD:self.maleCount and:self.femaleCount];
    
    NSString *ratio = [NSString stringWithFormat:@"%d/%d", numerator, denomenator];
    
    return ratio;
}

-(float)percentMale{
    return [self getPercent:self.maleCount];
}

-(float)percentFemale{
    return [self getPercent:self.femaleCount];
}

-(float)percentUnderEighteen{
    return [self getPercent:self.underEighteen];
}

-(float)percentEighteenToTwentyfive{
    return [self getPercent:self.eighteenToTwentyFive];
}

-(float)percentTwentyfiveToThirtyfive{
    return [self getPercent:self.twentyFiveToThirtyFive];
}

-(float)percentThirtyfiveToFourtyFive{
    return [self getPercent:self.thirtyFiveToFourtyFive];
}

-(float)percentFourtyfiveToFiftyfive{
    return [self getPercent:self.fourtyFiveToFiftyFive];
}

-(float)percentGreaterThanFiftyFive{
    return [self getPercent:self.greaterThan55];
}

-(float)getPercent: (float) number{
    float decimal = number/self.totalCount;
    float percent = decimal * 100;
    return percent;
}

@end
