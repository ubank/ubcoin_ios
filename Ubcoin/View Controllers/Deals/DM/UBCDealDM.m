//
//  UBCDealDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCDealDM.h"
#import "UBCDealCell.h"

#import "Ubcoin-Swift.h"

@implementation UBCDealDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _ID = dict[@"id"];
        _status = dict[@"status"];
        _item = [[UBCGoodDM alloc] initWithDictionary:dict[@"item"]];
        _buyer = [[UBCSellerDM alloc] initWithDictionary:dict[@"buyer"]];
        _seller = [[UBCSellerDM alloc] initWithDictionary:dict[@"seller"]];
        _statusDescriptions = [dict[@"statusDescriptions"] map:^id(id item) {
            return [UBCDealStatusDM.alloc initWithDictionary:item];
        }];
    }
    
    return self;
}

- (UBCDealStatusDM *)currentStatus
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.selected == 1"];
    return [[self.statusDescriptions filteredArrayUsingPredicate:predicate] lastObject];
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = self.item.rowData;
    data.data = self;
    data.className = NSStringFromClass(UBCDealCell.class);
    return data;
}

- (NSArray<UBTableViewSectionData *> *)sectionsData
{
    NSMutableArray *sections = [NSMutableArray array];
    
    [sections addObject:self.itemSection];
    [sections addObject:self.statusSection];
    
    return sections;
}

- (UBTableViewSectionData *)itemSection
{
    UBTableViewSectionData *section = UBTableViewSectionData.new;
    
    UBTableViewRowData *row = UBTableViewRowData.new;
    row.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    row.title = self.item.title;
    row.desc = [NSString stringWithFormat:@"%@ %@ / %@ ETH", self.item.priceInCurrency, self.item.currency, self.item.priceInETH];
    row.name = ItemRow;
    section.rows = @[row];
    
    return section;
}

- (UBTableViewSectionData *)statusSection
{
    UBTableViewSectionData *section = UBTableViewSectionData.new;
    
    UBTableViewRowData *row = UBTableViewRowData.new;
    row.disableHighlight = YES;
    row.desc = UBLocalizedString(@"str_purchase_process_desc", nil);
    section.rows = @[row];
    
    return section;
}

@end
