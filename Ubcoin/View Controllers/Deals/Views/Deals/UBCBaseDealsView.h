//
//  UBCBaseDealsView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBCDealDM.h"

@class UBCDealDM;
@class UBCGoodDM;
@protocol UBCDealsViewDelegate <NSObject>

@optional
- (void)showItem:(UBCGoodDM *)item;

@end

@interface UBCBaseDealsView : UIView <UBDefaultTableViewDelegate>

@property (weak, nonatomic) id<UBCDealsViewDelegate> delegate;
@property (strong, nonatomic) UBDefaultTableView *tableView;

- (void)setupEmptyView;
- (void)updateInfo;
- (void)reloadData;
- (void)handleResponse:(NSArray *)deals;

@end
