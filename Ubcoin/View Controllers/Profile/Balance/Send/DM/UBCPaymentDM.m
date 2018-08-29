//
//  UBCPaymentDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 18.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCPaymentDM.h"

@implementation UBCPaymentDM

- (BOOL)valid
{
    return self.address.isNotEmpty &&
    self.amount.doubleValue > 0;
}

- (NSNumber *)totalAmount
{
    return @(self.amount.doubleValue + self.commission.doubleValue);
}

- (NSArray<UBTableViewRowData *> *)rowsData
{
    NSMutableArray *rows = [NSMutableArray array];
    
    UBTableViewRowData *row = UBTableViewRowData.new;
    row.title = UBLocalizedString(@"str_address", nil);
    row.desc = self.address;
    row.disableHighlight = YES;
    [rows addObject:row];
    
    UBTableViewRowData *row2 = UBTableViewRowData.new;
    row2.title = UBLocalizedString(@"str_amount", nil);
    row2.desc = [NSString stringWithFormat:@"%@ UBC", self.amount.priceString];
    row2.disableHighlight = YES;
    [rows addObject:row2];
    
    UBTableViewRowData *row3 = UBTableViewRowData.new;
    row3.title = UBLocalizedString(@"str_transaction_commission", nil);
    row3.desc = [NSString stringWithFormat:@"%@ UBC", self.commission.priceString];
    row3.disableHighlight = YES;
    [rows addObject:row3];
    
    UBTableViewRowData *row4 = UBTableViewRowData.new;
    row4.title = UBLocalizedString(@"str_total_amount", nil);
    row4.desc = [NSString stringWithFormat:@"%@ UBC", self.totalAmount.priceString];
    row4.disableHighlight = YES;
    row4.height = 95;
    [rows addObject:row4];
    
    return rows;
}

@end
