//
//  ASHSpringyCollectionViewFlowLayout.m
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

/*
 
 This implementation is based on https://github.com/TeehanLax/UICollectionView-Spring-Demo
 which I developed at Teehan+Lax. Check it out.
 
 */

#import "HUBSpringyCollectionViewFlowLayout.h"

#define SCROLL_RESISTANCE_DIVIDE_VALUE 1700

@interface HUBSpringyCollectionViewFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, assign) CGPoint latestOffset;

@end


@implementation HUBSpringyCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }

    return self;
}

- (void)invalidateSpringLayout
{
    self.latestOffset = self.collectionView.contentOffset;
    [self.dynamicAnimator removeAllBehaviors];
    [self invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // Need to enlarge visible rect slightly to avoid flickering.
    CGRect visibleArea = CGRectInset((CGRect){
        .origin = CGPointMake(self.collectionView.bounds.origin.x,
                              self.collectionView.bounds.origin.y),
        .size = CGSizeMake(self.collectionView.bounds.size.width,
                           self.collectionView.bounds.size.height + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom)
    }, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleArea];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    // Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehavioursCells = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[[behaviour items] firstObject];
        
        return [itemsIndexPathsInVisibleRectSet member:[item indexPath]] == nil;
    }]];
    
    [noLongerVisibleBehavioursCells enumerateObjectsUsingBlock:^(UIAttachmentBehavior *behaviour, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:behaviour];
    }];
    
    // Add any newly visible behaviours.
    NSArray *cells = [self.dynamicAnimator.behaviors map:^(UIAttachmentBehavior *behaviour)
    {
        return [behaviour.items firstObject];
    }];
    
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        NSArray *exisingCells = [cells filteredArrayUsingPredicate:[NSPredicate
                                                                    predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *existingItem, NSDictionary *bindings)
                                                                    {
                                                                        BOOL simpleCheck = existingItem.indexPath == item.indexPath &&
                                                                        existingItem.representedElementCategory == item.representedElementCategory;
                                                                        
                                                                        if (!simpleCheck)
                                                                        {
                                                                            return NO;
                                                                        }
                                                                        
                                                                        return ((existingItem.representedElementKind == nil && item.representedElementKind == nil)
                                                                                || [existingItem.representedElementKind isEqualToString:item.representedElementKind]);
                                                                        
                                                                    }]];
        
        return exisingCells.count == 0;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 1.0f;
        springBehaviour.damping = 1.0f;
        springBehaviour.frequency = 3.8f;
        
        CGFloat staticCenterX = item.center.x;
        
        springBehaviour.action = ^{
            CGPoint center = item.center;
            center.x = staticCenterX;
            item.center = center;
        };
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation))
        {
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / SCROLL_RESISTANCE_DIVIDE_VALUE;
            
            if (self.latestDelta < 0)
            {
                center.y += MAX(self.latestDelta, self.latestDelta * scrollResistance);
            }
            else
            {
                center.y += MIN(self.latestDelta, self.latestDelta * scrollResistance);
            }
            item.center = center;
        }
        [self.dynamicAnimator addBehavior:springBehaviour];
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [self.dynamicAnimator layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;

    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / SCROLL_RESISTANCE_DIVIDE_VALUE;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0)
        {
            center.y += MAX(delta, delta * scrollResistance);
        }
        else
        {
            center.y += MIN(delta, delta * scrollResistance);
        }
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return self.latestOffset;
}

@end
