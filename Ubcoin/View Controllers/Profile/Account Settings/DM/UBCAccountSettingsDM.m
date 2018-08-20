//
//  UBCAccountSettingsDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 15.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCAccountSettingsDM.h"
#import "UBCUserDM.h"

@implementation UBCAccountSettingsDM

+ (NSArray<UBTableViewSectionData *> *)fields
{
    UBCUserDM *user = [UBCUserDM loadProfile];
    if (user)
    {
        UBTableViewSectionData *section = UBTableViewSectionData.new;
        section.headerTitle = [UBLocalizedString(@"str_common", nil) uppercaseString];
        
        NSMutableArray *rows = [NSMutableArray array];
        
        UBTableViewRowData *row = UBTableViewRowData.new;
        row.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        row.title = UBLocalizedString(@"str_name", nil);
        row.rightTitle = user.name;
        row.name = CHANGE_NAME_ACTION;
        [rows addObject:row];
        
        UBTableViewRowData *row2 = UBTableViewRowData.new;
        row2.title = UBLocalizedString(@"str_email", nil);
        row2.rightTitle = user.email;
        row2.disableHighlight = YES;
        [rows addObject:row2];
        
//        UBTableViewRowData *row3 = UBTableViewRowData.new;
//        row3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        row3.title = UBLocalizedString(@"str_country", nil);
//        row3.name = CHANGE_COUNTRY_ACTION;
//        [rows addObject:row3];

//        UBTableViewRowData *row4 = UBTableViewRowData.new;
//        row4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        row4.title = UBLocalizedString(@"str_language", nil);
//        row4.rightTitle = [self currentLanguage];
//        row4.name = CHANGE_LANGUAGE_ACTION;
//        [rows addObject:row4];
        
//        UBTableViewRowData *row5 = UBTableViewRowData.new;
//        row5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        row5.title = UBLocalizedString(@"str_my_reviews", nil);
//        row5.rightTitle = [NSString stringWithFormat:@"%d", (int)user.reviewsCount];
//        row5.name = SHOW_REVIEWS_ACTION;
//        [rows addObject:row5];
        
        section.rows = rows;
        
        return @[section];
    }
    return nil;
}

+ (NSString *)currentLanguage
{
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:UBLocal.shared.language];
}

+ (NSArray<UBTableViewRowData *> *)currentLocalizations
{
    NSArray *languages = [[NSBundle mainBundle] localizations];
    
    NSMutableArray *rows = [NSMutableArray array];
    for (NSString *lang in languages)
    {
        UBTableViewRowData *row = UBTableViewRowData.new;
        row.title = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:lang];
        row.name = lang;
        row.isSelected = [lang isEqualToString:UBLocal.shared.language];
        row.accessoryType = row.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        [rows addObject:row];
    }
    
    return rows;
}

@end
