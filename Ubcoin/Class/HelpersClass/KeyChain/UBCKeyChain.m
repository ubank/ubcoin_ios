//
//  UBCKeyChain.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCKeyChain.h"

@implementation UBCKeyChain

#define CHECK_KEY @"is not first entry"
#define kPathAuthorization [BUNDLE_ID stringByAppendingString:@"ubcoin.credential.authorization"]

#pragma mark - Inner Methods

+ (int)saveString:(NSString *)inputString forKey:(NSString  *)account
{
    if (account.length == 0 || !account)
    {
        return 10000;
    }
    
    if (inputString.length == 0 || !inputString)
    {
        return 10001;
    }
    
    NSMutableDictionary *query = NSMutableDictionary.new;
    
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge id)kSecAttrAccount] = account;
    query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
    
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    
    NSData *inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    if (error == errSecSuccess)
    {
        NSDictionary *attributesToUpdate = @{(__bridge id)kSecValueData: inputData};
        
        error = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
        
    }
    else if (error == errSecItemNotFound)
    {
        // do add
        query[(__bridge id)kSecValueData] = inputData;
        error = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    
    return (int)error;
}

+ (NSString *)getStringForKey:(NSString *)account
{
    if (account.length == 0 || !account)
    {
        return nil;
    }
    
    NSMutableDictionary *query = NSMutableDictionary.new;
    
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge id)kSecAttrAccount] = account;
    query[(__bridge id)kSecReturnData] = (id)kCFBooleanTrue;
    
    CFDataRef outData = nil;
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&outData);
    NSData *dataFromKeychain = (__bridge_transfer NSData *)outData;
    NSString *stringToReturn;
    if (error == errSecSuccess)
    {
        stringToReturn = [NSString.alloc initWithData:dataFromKeychain encoding:NSUTF8StringEncoding];
    }
    
    return stringToReturn;
}

+ (int)deleteStringForKey:(NSString *)account
{
    if (account.length == 0 || !account)
    {
        return 10000;
    }
    
    NSMutableDictionary *query = NSMutableDictionary.new;
    
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge id)kSecAttrAccount] = account;
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    return (int)status;
}

#pragma mark - Handler Login

+ (void)setAuthorization:(NSString *)authorization
{
    [self saveString:authorization forKey:kPathAuthorization];
}

+ (NSString *)authorization
{
    return [self getStringForKey:kPathAuthorization];
}

+ (void)removeAuthorization
{
    [self deleteStringForKey:kPathAuthorization];
}

#pragma mark -

+ (void)checkForReset
{
    NSNumber *key = [[NSUserDefaults standardUserDefaults] objectForKey:CHECK_KEY];
    if (!key)
    {
        [UBCKeyChain removeAuthorization];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:CHECK_KEY];
    }
}

@end
