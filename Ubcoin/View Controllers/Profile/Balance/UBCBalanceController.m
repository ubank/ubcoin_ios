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

#import "Ubcoin-Swift.h"

@interface UBCBalanceController () <UBDefaultTableViewDelegate>

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;
@property (weak, nonatomic) IBOutlet HUBLabel *balance;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *topupButton;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *sendButton;

@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) NSUInteger pageNumber;
@property (assign, nonatomic) BOOL isETH;

@end

@implementation UBCBalanceController

- (instancetype)initWithETH:(BOOL)isETH
{
    self = [super init];
    if (self)
    {
        self.isETH = isETH;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_my_balance";
    
    self.pageNumber = 0;
    
    [self setupViews];
    [self setupBalance];
    
    [self startActivityIndicatorImmediately];
    [self updateInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(update)
                                                 name:kNotificationHistoryChanged
                                               object:nil];
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
        [weakSelf update];
    }];
}

#pragma mark -

- (void)update
{
    self.pageNumber = 0;
    [self updateInfo];
}

- (void)updateInfo
{
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider transactionsListWithPageNumber:self.pageNumber
                                                             isETH:self.isETH
                                               withCompletionBlock:^(BOOL success, NSArray *transactions, BOOL canLoadMore)
     {
         [weakSelf handleResponseWithStatus:success transactions:transactions canLoadMore:canLoadMore];
     }];
    
    [UBCDataProvider.sharedProvider updateBalanceWithCompletionBlock:^(BOOL success)
     {
         if (success)
         {
             [weakSelf setupBalance];
         }
     }];
}

#pragma mark -

- (void)handleResponseWithStatus:(BOOL)success transactions:(NSArray *)transactions canLoadMore:(BOOL)canLoadMore
{
    [self stopActivityIndicator];
    [self.tableView.refreshControll endRefreshing];
    if (success)
    {
        self.tableView.canLoadMore = canLoadMore;
    }
    
    if (transactions)
    {
        if (self.pageNumber == 0)
        {
            self.items = [NSMutableArray array];
        }
        [self.items addObjectsFromArray:transactions];
        self.pageNumber++;
    }
    self.tableView.emptyView.hidden = self.items.count > 0;
    [self.tableView updateWithRowsData:self.items];
}

- (void)setupBalance
{
    UBCBalanceDM *balance = [UBCBalanceDM loadBalance];
    if (self.isETH)
    {
        self.balance.text = [NSString stringWithFormat:@"%@ ETH", balance.amountETH.priceString];
    }
    else
    {
        self.balance.text = [NSString stringWithFormat:@"%@ UBC", balance.amountUBC.priceString];
    }
}

#pragma mark - Actions

- (IBAction)topup
{
    [self startActivityIndicator];
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider topupWithCompletionBlock:^(BOOL success, UBCTopupDM *topup)
     {
         [weakSelf stopActivityIndicator];
         if (success && topup)
         {
             UBCTopUpController *controller = [[UBCTopUpController alloc] initWithTopup:topup isETH:self.isETH];
             [weakSelf.navigationController pushViewController:controller animated:YES];
         }
     }];
}

- (IBAction)send
{
    UBCSendCoinsController *controller = [[UBCSendCoinsController alloc] initWithETH:self.isETH];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)didSelectData:(UBTableViewRowData *)data indexPath:(NSIndexPath *)indexPath
{
    UBCTransactionInfoController *controller = [UBCTransactionInfoController.alloc initWithTransaction:data.data];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
