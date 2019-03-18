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

- (instancetype)initWithDictionary:(NSDictionary *)dict isETH:(BOOL)isETH
{
    self = [super init];
    if (self)
    {
        _isETH = isETH;
        _ID = dict[@"id"];
        _from = dict[@"from"];
        _to = dict[@"to"];
        _amount = isETH ? dict[@"amountETH"] : dict[@"amountUBC"];
        _status = dict[@"status"];
        _date = [NSDate dateFromString:dict[@"createdDate"] inFormat:@"yyyyMMdd'T'HHmmssZ"];
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
    UIColor *textColor = [self amountColor];
    NSString *string = [NSString stringWithFormat:@"  %@", self.priceWithCurrency];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: textColor}];
    
    if ([self.status isEqualToString:@"IN_PROGRESS"])
    {
        NSTextAttachment *textAttachment = NSTextAttachment.new;
        textAttachment.image = [UIImage imageNamed:@"history_pending"];
        textAttachment.bounds = CGRectMake(0, (UBFont.descFont.pointSize - textAttachment.image.size.height), textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [text insertAttributedString:attrStringWithImage atIndex:0];
    }
    else if ([self.status isEqualToString:@"REJECTED"])
    {
        NSTextAttachment *textAttachment = NSTextAttachment.new;
        textAttachment.image = [UIImage imageNamed:@"history_fail"];
        textAttachment.bounds = CGRectMake(0, (UBFont.descFont.pointSize - textAttachment.image.size.height), textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [text insertAttributedString:attrStringWithImage atIndex:0];
    }
    
    return text;
}

- (UIColor *)amountColor
{
    if ([self.status isEqualToString:@"REJECTED"])
    {
        return RED_COLOR;
    }
    
    return self.amount.doubleValue > 0 ? UBCColor.green : UBColor.titleColor;
}

- (NSString *)currency
{
    return self.isETH ? @"ETH" : @"UBC";
}

- (NSString *)priceWithCurrency
{
    NSString *amount = self.isETH ? self.amount.coinsPriceString : self.amount.priceString;
    NSString *amountString = self.amount.doubleValue > 0 ? [NSString stringWithFormat:@"+ %@", amount] : amount;
    return [NSString stringWithFormat:@"%@ %@", amountString, self.currency];
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
    
    if (self.from.isNotEmpty)
    {
        UBTableViewRowData *row3 = UBTableViewRowData.new;
        row3.title = UBLocalizedString(@"str_from", nil);
        row3.desc = self.from;
        row3.disableHighlight = YES;
        [rows addObject:row3];
    }
    
    if (self.to.isNotEmpty)
    {    
        UBTableViewRowData *row4 = UBTableViewRowData.new;
        row4.title = UBLocalizedString(@"str_to", nil);
        row4.desc = self.to;
        row4.disableHighlight = YES;
        [rows addObject:row4];
    }
    
    return rows;
}

@end
