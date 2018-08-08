//
//  UBCBaseDealsView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBCBaseDealsView : UIView <UBDefaultTableViewDelegate>

@property (strong, nonatomic) UBDefaultTableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSUInteger pageNumber;

- (void)updateInfo;

@end
