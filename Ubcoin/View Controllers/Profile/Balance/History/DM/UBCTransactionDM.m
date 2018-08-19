//
//  UBCTransactionDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 17.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCTransactionDM.h"

#import "Ubcoin-Swift.h"

@implementation UBCTransactionDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _from = dict[@"from"];
        _to = dict[@"to"];
        _amount = dict[@"amount"];
        _status = dict[@"status"];
        _date = [NSDate dateFromISO8601String:dict[@"createdDate"]];
    }
    return self;
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data.data = self;
    data.desc = [NSDate stringFromDateInFormat_dd_MM_yyyy:self.date];
    data.attributedRightDesc = [self amountString];
    return data;
}

- (NSAttributedString *)amountString
{
    UIColor *textColor = self.amount.doubleValue > 0 ? UBColor.titleColor : UBCColor.green;
    NSString *string = [NSString stringWithFormat:@" %@ UBC", self.amount.priceString];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: textColor}];
    
    if ([self.status isEqualToString:@"IN_PROGRESS"])
    {
        NSTextAttachment *textAttachment = NSTextAttachment.new;
        textAttachment.image = [UIImage imageNamed:@"history_pending"];
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [text insertAttributedString:attrStringWithImage atIndex:0];
    }
    
    return text;
}

- (NSArray<UBTableViewRowData *> *)rowsData
{
    NSMutableArray *rows = [NSMutableArray array];
    
    UBTableViewRowData *row = UBTableViewRowData.new;
    row.title = UBLocalizedString(@"str_transaction_id", nil);
    row.desc = self.ID;
    row.disableHighlight = YES;
    [rows addObject:row];
    
    UBTableViewRowData *row2 = UBTableViewRowData.new;
    row2.title = UBLocalizedString(@"str_transaction_receipt_status", nil);
    row2.desc = self.status;
    row2.disableHighlight = YES;
    [rows addObject:row2];
    
    UBTableViewRowData *row3 = UBTableViewRowData.new;
    row3.title = UBLocalizedString(@"str_from", nil);
    row3.desc = self.from;
    row3.disableHighlight = YES;
    [rows addObject:row3];
    
    UBTableViewRowData *row4 = UBTableViewRowData.new;
    row4.title = UBLocalizedString(@"str_to", nil);
    row4.desc = self.to;
    row4.disableHighlight = YES;
    [rows addObject:row4];
    
    return rows;
}

@end
