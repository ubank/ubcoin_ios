//
//  UBNotificationHandler.m
//  uBank
//
//  Created by Alex Ostroushko on 29/07/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

#import "UBCNotificationHandler.h"
#import "UBCAppDelegate.h"
#import "UBCKeyChain.h"

#import "UBCGoodDetailsController.h"

#import "Ubcoin-Swift.h"

#define PUSH_ACTIVITY @"activityName"

@implementation UBCNotificationHandler

#pragma mark - Handle Actions

+ (void)openURL:(NSURL *)url
{
    if (!url || !url.absoluteString.isNotEmpty)
    {
        return;
    }
    
    if ([self isUbcoinURLScheme:url])
    {
        [self handleActivity:url.host withParams:[NSDictionary dictionaryParamsFromURL:url]];
    }
    else
    {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
    }
}

+ (void)handleActivity:(NSString *)activity withParams:(NSDictionary *)params
{
    if (![self needHandleActivity:activity withParams:params])
    {
        return;
    }
    
    UIViewController *controller = [self controllerForActivityName:activity withParams:params];
    if (controller)
    {
        UBViewController *shownController = [mainAppDelegate showControllers:@[controller]];
        if (shownController && params && [shownController isKindOfClass:UBViewController.class])
        {
            [shownController updateInfoWithPushParams:params];
        }
    }
}

#pragma mark - Check Methods

+ (BOOL)isUbcoinURLScheme:(NSURL *)url
{
    return [[NSString stringWithFormat:@"%@://", url.scheme] isEqualToString:URL_SCHEME];
}

+ (BOOL)needHandleActivity:(NSString *)activity withParams:(NSDictionary *)params
{
    UBViewController *visibleViewController = (UBViewController *)mainAppDelegate.navigationController.currentController;
    if ([self.commonActivities containsObject:activity])
    {
        UIViewController *controller = [self controllerForActivityName:activity withParams:params];
        if (controller)
        {
            if ([visibleViewController isKindOfClass:controller.class] &&
                [visibleViewController isKindOfClass:UBViewController.class])
            {
                [visibleViewController updateInfo];
                
                if (params)
                {
                    [visibleViewController updateInfoWithPushParams:params];
                }
                
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - Activities Handle

+ (BOOL)needShowPushWithUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *data = userInfo[@"data"];
    if (data)
    {
        return [self needHandleActivity:data[PUSH_ACTIVITY]
                             withParams:data];
    }
    
    return YES;
}

+ (void)handlePushWithUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *data = userInfo[@"data"];
    if (data)
    {
        [UBCNotificationHandler handleActivity:data[PUSH_ACTIVITY] withParams:data];
    }
}

+ (UIViewController *)controllerForActivityName:(NSString *)activity
                                     withParams:(NSDictionary *)params
{
    if (![activity isNotEmpty])
    {
        return nil;
    }
    
    if (!UBCKeyChain.authorization && [self.registrationActivities containsObject:activity])
    {
        return [UBCStartLoginController new];
    }
    else if ([activity isEqualToString:ITEM_ACTIVITY])
    {
        return [UBCGoodDetailsController.alloc initWithGoodID:params[@"id"]];
    }
    else if ([activity isEqualToString:SELLER_ACTIVITY])
    {
        return [UBCSellerController.alloc initWithSellerID:params[@"id"]];
    }
    else if ([activity isEqualToString:CHAT_ACTIVITY])
    {
        return [UBCChatController.alloc initWithItemID:params[@"itemId"] userID:params[@"userId"]];
    }
    else if ([activity isEqualToString:PURCHASE_ACTIVITY])
    {
        return [UBCDealInfoController.alloc initWithDealID:params[@"id"]];
    }
    
    return nil;
}

+ (NSURL *)urlForActivity:(NSString *)activity withKeys:(NSArray *)keys values:(NSArray *)values
{
    if (activity.isNotEmpty)
    {
        NSMutableString *stringOfURL;
        
        if (keys && values && keys.count == values.count)
        {
            stringOfURL = [NSMutableString stringWithFormat:@"%@%@?", URL_SCHEME, activity];
            
            for (int i = 0; i < keys.count; i++)
            {
                NSString *key = keys[i];
                NSString *value = values[i];
                [stringOfURL appendFormat:@"%@=%@&", key, value];
            }
            
            if ([stringOfURL hasSuffix:@"&"])
            {
                [stringOfURL deleteCharactersInRange:NSMakeRange(stringOfURL.length - 1, 1)];
            }
        }
        else
        {
            stringOfURL = [URL_SCHEME stringByAppendingString:activity].mutableCopy;
        }
        
        return [NSURL URLWithString:[stringOfURL stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet]];
    }
    
    return nil;
}

#pragma mark - Activity Lists

+ (NSArray *)commonActivities
{
    return @[ITEM_ACTIVITY,
             SELLER_ACTIVITY,
             CHAT_ACTIVITY,
             PURCHASE_ACTIVITY
             ];
}

+ (NSArray *)registrationActivities
{
    return @[CHAT_ACTIVITY,
             PURCHASE_ACTIVITY
             ];
}

@end
