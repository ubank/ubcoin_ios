//
//  UBDefaultTableView.h
//  Halva
//
//  Created by Alex Ostroushko on 22.05.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "UBSectionHeaderView.h"

@protocol UBDefaultTableViewDelegate <NSObject>

@optional
- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath;
- (void)editData:(UBTableViewRowData *)data commitEditingStyle:(UITableViewCellEditingStyle)editingStyle indexPath:(NSIndexPath *)indexPath;

- (void)prepareCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data;
- (void)layoutCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath;

- (void)prepareHeaderView:(UBSectionHeaderView *)headerView;
- (void)prepareFooterView:(UBSectionHeaderView *)footerView;

- (void)updatePagination;

@end


@interface UBDefaultTableView : UBTableView

@property (weak, nonatomic) IBOutlet id<UBDefaultTableViewDelegate> actionDelegate;

@property (assign, nonatomic) BOOL canLoadMore;

- (void)updateWithSectionsData:(NSArray<UBTableViewSectionData *> *)sections;
- (void)updateWithRowsData:(NSArray<UBTableViewRowData *> *)rows;

- (UBTableViewRowData *)rowDataForIndexPath:(NSIndexPath *)indexPath;

@end
