//
//  UBCTransactionInfoController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 17.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCTransactionInfoController.h"
#import "UBCTransactionDM.h"

@interface UBCTransactionInfoController () <UBDefaultTableViewDelegate>

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;
@property (weak, nonatomic) IBOutlet HUBLabel *amount;

@property (strong, nonatomic) UBCTransactionDM *transaction;

@end

@implementation UBCTransactionInfoController

- (instancetype)initWithTransaction:(UBCTransactionDM *)transaction
{
    self = [super init];
    if (self)
    {
        self.transaction = transaction;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_transaction_info";
    
    [self setupContent];
}

- (void)setupContent
{
    self.amount.text = [NSString stringWithFormat:@"%@ %@", self.transaction.amount.priceString, self.transaction.currency];
    [self.tableView updateWithRowsData:self.transaction.rowsData];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)prepareCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data
{
    cell.title.textColor = UBColor.descColor;
    cell.title.font = UBFont.descFont;
    
    cell.desc.textColor = UBColor.titleColor;
    cell.desc.font = UBFont.titleFont;
}

@end
