//
//  UBCGoodsCollectionView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCGoodsCollectionView.h"
#import "HUBSpringyCollectionViewFlowLayout.h"
#import "UBCGoodCell.h"

@implementation UBCGoodsCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionViewLayout = HUBSpringyCollectionViewFlowLayout.new;
    
    [self setup];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:HUBSpringyCollectionViewFlowLayout.new];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

#pragma mark -

- (void)setup
{
    
}

@end
