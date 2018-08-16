//
//  UBCAccountSettingsDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 15.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHANGE_NAME_ACTION @"name"
#define CHANGE_COUNTRY_ACTION @"country"
#define CHANGE_LANGUAGE_ACTION @"language"
#define SHOW_REVIEWS_ACTION @"reviews"

@interface UBCAccountSettingsDM : NSObject

+ (NSArray<UBTableViewSectionData *> *)fields;
+ (NSArray<UBTableViewRowData *> *)currentLocalizations;

@end
