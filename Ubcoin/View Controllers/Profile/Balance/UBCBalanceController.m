//
//  UBCBalanceController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCBalanceController.h"
#import "UBCTransactionInfoController.h"
#import "UBCSendCoinsController.h"
#import "UBCBalanceDM.h"
#import "UBCTransactionDM.h"
#import "UBCTopupView.h"

#import "Ubcoin-Swift.h"

@interface UBCBalanceController () <UBDefaultTableViewDelegate>

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;
@property (weak, nonatomic) IBOutlet HUBLabel *balance;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *topupButton;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *sendButton;

@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSUInteger pageNumber;

@end

@implementation UBCBalanceController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_my_balance";
    
    self.pageNumber = 0;
    
    UBCBalanceDM *balance = [UBCBalanceDM loadBalance];
    self.balance.text = [NSString stringWithFormat:@"%@ UBC", balance.amountUBC.priceString];
    
    [self setupViews];
    
    [self startActivityIndicatorImmediately];
    [self updateInfo];
}

- (void)setupViews
{
    self.topupButton.backgroundColor = UBCColor.green;
    self.topupButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.sendButton.backgroundColor = UBCColor.green;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.tableView.emptyView.icon.image = nil;
    self.tableView.emptyView.title.text = UBLocalizedString(@"str_transaction_history", nil);
    self.tableView.emptyView.desc.text = UBLocalizedString(@"str_transaction_history_desc", nil);
    
    [self.tableView setTopConstraintToSubview:self.tableView.emptyView
                                    withValue:self.tableView.tableHeaderView.height];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView setupRefreshControllWithActionBlock:^{
        weakSelf.pageNumber = 0;
        [weakSelf updateInfo];
    }];
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider transactionsListWithPageNumber:self.pageNumber
                                               withCompletionBlock:^(BOOL success, NSArray *goods, BOOL canLoadMore)
     {
         [weakSelf stopActivityIndicator];
         [weakSelf.tableView.refreshControll endRefreshing];
         if (success)
         {
             weakSelf.tableView.canLoadMore = canLoadMore;
         }
         
         if (goods)
         {
             if (weakSelf.pageNumber == 0)
             {
                 weakSelf.items = [NSMutableArray array];
             }
             [weakSelf.items addObjectsFromArray:goods];
             weakSelf.pageNumber++;
         }
         weakSelf.tableView.emptyView.hidden = weakSelf.items.count > 0;
         [weakSelf.tableView updateWithRowsData:weakSelf.items];
     }];
}

#pragma mark - Actions

- (IBAction)topup
{
    [self startActivityIndicator];
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider topupWithCompletionBlock:^(BOOL success, NSString *qrCodeURL, NSString *address) {
        [weakSelf stopActivityIndicator];
        if (success)
        {
            UBCTopupView *view = [UBCTopupView show];
            [view setupWithQRCodeURL:qrCodeURL address:address];
        }
    }];
}

- (IBAction)send
{
    [self.navigationController pushViewController:UBCSendCoinsController.new animated:YES];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCTransactionInfoController *controller = [UBCTransactionInfoController.alloc initWithTransaction:data.data];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
