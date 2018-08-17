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
    NSString *string = [NSString stringWithFormat:@"%@ UBC", self.amount.priceString];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: textColor}];
    
    return text;
}

@end
