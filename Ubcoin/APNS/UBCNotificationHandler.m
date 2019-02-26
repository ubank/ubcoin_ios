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
        [self handleURL:url];
    }
    else
    {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
    }
}

+ (void)handleURL:(NSURL *)url
{
    if (![self needHandleURL:url])
    {
        return;
    }
    
    UBViewController *controller = [self controllerForURL:url];
    if (controller)
    {
        UBViewController *shownController = [mainAppDelegate showControllers:@[controller]];
        
        if (shownController)
        {
            NSDictionary *params = [NSDictionary dictionaryParamsFromURL:url];
            if (params)
            {
                [shownController updateInfoWithPushParams:params];
            }
        }
    }
}

#pragma mark - Check Methods

+ (BOOL)isUbcoinURLScheme:(NSURL *)url
{
    return [[NSString stringWithFormat:@"%@://", url.scheme] isEqualToString:URL_SCHEME];
}

+ (BOOL)needHandleURL:(NSURL *)url
{
    NSString *activity = url.host;
    
    UBViewController *visibleViewController = (UBViewController *)mainAppDelegate.navigationController.currentController;
    if ([self.commonActivities containsObject:activity])
    {
        NSDictionary *params = [NSDictionary dictionaryParamsFromURL:url];
        UBViewController *controller = [self controllerForActivityName:activity withParams:params];
        
        if (controller && [visibleViewController isKindOfClass:UBViewController.class])
        {
            if ([visibleViewController isKindOfClass:controller.class])
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

+ (UBViewController *)controllerForURL:(NSURL *)url
{
    NSString *activity = url.host;
    
    if (![activity isNotEmpty])
    {
        return nil;
    }
    
    NSDictionary *params = [NSDictionary dictionaryParamsFromURL:url];
    
    UBViewController *controller = [self controllerForActivityName:activity withParams:params];
    if (controller)
    {
        if (!UBCKeyChain.authorization && [self.registrationActivities containsObject:activity])
        {
            return [UBCStartLoginController new];
        }
        else
        {
            return controller;
        }
    }
    
    return nil;
}

+ (UBViewController *)controllerForActivityName:(NSString *)activity
                                     withParams:(NSDictionary *)params
{
    if ([activity isEqualToString:ITEM_ACTIVITY])
    {
        return [UBCGoodDetailsController.alloc initWithGoodID:params[@"id"]];
    }
    else if ([activity isEqualToString:SELLER_ACTIVITY])
    {
        return [UBCSellerController.alloc initWithSellerID:params[@"id"]];
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
             SELLER_ACTIVITY
             ];
}

+ (NSArray *)registrationActivities
{
    return @[
             ];
}

@end
