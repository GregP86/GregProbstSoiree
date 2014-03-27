//
//  GGPDeleteCell.m
//  Soiree
//
//  Created by Greg Probst on 3/12/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPDeleteCell.h"

@implementation GGPDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteEvent:(id)sender {

    
    PFQuery *query = [PFQuery queryWithClassName:@"LogEntry"];
    [query getObjectInBackgroundWithId:self.log.id block:^(PFObject *entryObj, NSError *error) {
        [entryObj deleteInBackground];
        [self.event removeObjectsInArray:@[self.log.id] forKey:@"Log"];
        [self.event saveInBackground];
    }];
    
    
}
@end
