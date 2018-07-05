//
//  UBCollectionViewSwitch.h
//  uBank
//
//  Created by RAVIL on 4/14/15.
//  Copyright (c) 2015 uBank. All rights reserved.
//

/* EXAMPLE
    
    UIView * view1 = [[UIView new];
    UIView * view2 = [[UIView new];
    UIView * view3 = [[UIView new];
 
    UBCollectionViewSwitchContent * contentOfView1 = [[UBCollectionViewSwitchContent alloc] initWithTitle:@"Title1"
                                                                                                     view:view1];
    UBCollectionViewSwitchContent * contentOfView2 = [[UBCollectionViewSwitchContent alloc] initWithTitle:@"Title2"
                                                                                                     view:view2];
    UBCollectionViewSwitchContent * contentOfView3 = [[UBCollectionViewSwitchContent alloc] initWithTitle:@"Title3"
                                                                                                     view:view3];
 
    //If needed set ".isSelected" to content
    //contentOfView2.isSelected = YES;
 
    NSArray * arrayOfContent = @[contentOfView1, contentOfView2, contentOfView3];
 
    UBCollectionViewSwitch * collectionViewSwitch = [UBCollectionViewSwitch alloc] initWithFrame:<#needed frame>
                                                                         withArrayOfPagesContent:arrayOfContent];
    collectionViewSwitch.backgroundColor = <#needed color>;
    [self.view addSubview:self.collectionView];
 
*/

#import "UBCollectionViewSwitchContent.h"

#define HEIGHT_OF_PANEL 48

@interface UBCollectionViewSwitch : UIView

@property (strong, nonatomic, readonly) UICollectionView *collectionView;
@property (assign, nonatomic, readonly) NSUInteger pageIndex;
@property (assign, nonatomic, readonly) NSUInteger numberOfPages;
@property (copy, nonatomic) void (^blockOfEndScrollingToPage)(NSUInteger page);

///To show buttons with view's titles. Default - YES;
@property (assign, nonatomic) BOOL showButtonsPanel;

- (instancetype)initWithFrame:(CGRect)frame withArrayOfPagesContent:(NSArray *)array;
- (void)updateArrayOfPagesContent:(NSArray *)array;

- (void)scrollToNextPage;
- (void)scrollToPage:(NSUInteger)pageIndex
        withAnimation:(BOOL)animation;
- (void)scrollToPage:(NSUInteger)pageIndex
        withAnimation:(BOOL)animation
           completion:(void (^)(NSUInteger centerPage))completionBlock;

@end
