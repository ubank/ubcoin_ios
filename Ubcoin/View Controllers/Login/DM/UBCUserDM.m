//
//  UBCUserDM.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 28.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCUserDM.h"

#define USER_KEY @"user profile"

@implementation UBCUserDM

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self)
    {
        _email = dict[@"email"];
        _authorizedInTg = [dict[@"authorizedInTg"] boolValue];
    }
    return self;
}

- (UBTableViewRowData *)rowData
{
    UBTableViewRowData *data = UBTableViewRowData.new;
    data.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    data.data = self;
    data.title = self.name;
//    data.iconURL = self.avatarURL;
//    data.icon = [UIImage imageNamed:@"def_prof"];
//    data.height = 80;
    return data;
}

+ (UBCUserDM *)loadProfile
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY];
    return [[UBCUserDM alloc] initWithDictionary:dict];
}

+ (void)saveUserDict:(NSDictionary *)dict
{
    if (dict)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_KEY];
    }
}

+ (void)updateUserDict:(NSDictionary *)dict
{
    NSMutableDictionary *userDict = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY] mutableCopy];
    [userDict addEntriesFromDictionary:dict];
    [UBCUserDM saveUserDict:userDict];
}

+ (void)clearUserData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
