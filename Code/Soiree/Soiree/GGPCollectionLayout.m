//
//  GGPCollectionLayout.m
//  Soiree
//
//  Created by Greg Probst on 2/7/14.
//  Copyright (c) 2014 Greg Probst. All rights reserved.
//

#import "GGPCollectionLayout.h"

@implementation GGPCollectionLayout
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.minimumLineSpacing = 15;
    self.sectionInset = UIEdgeInsetsMake(7.5f, 7.5f, 30.0f, 7.5f);
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
}

- (CGSize)collectionViewContentSize
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger pages = ceil(itemCount / 12.0);
    
    return CGSizeMake(320 * pages, self.collectionView.frame.size.height);
    
}

@end
