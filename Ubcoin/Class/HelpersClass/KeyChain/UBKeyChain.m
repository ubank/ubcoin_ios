//
//  UBKeyChain.m
//  uBank
//
//  Created by Yauheni Zinchanka on 5/13/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

#import "UBKeyChain.h"

@implementation UBKeyChain

#define kPathAuthorization [BUNDLE_ID stringByAppendingString:@"halva.credential.authorization"]
#define kPathLogin [BUNDLE_ID stringByAppendingString:@"halva.credential.login"]
#define kPathTid [BUNDLE_ID stringByAppendingString:@"halva.security.tid"]
#define kPathPin [BUNDLE_ID stringByAppendingString:@"halva.security.pin"]
#define kPathHWIDKey [BUNDLE_ID stringByAppendingString:@"halva.security.hwid"]

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
    
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationFakeTidWasUpdated object:nil];
}

+ (NSString *)authorization
{
    return [self getStringForKey:kPathAuthorization];
}

+ (void)removeAuthorization
{
    [self deleteStringForKey:kPathAuthorization];
}

#pragma mark - Handler Login

+ (void)setLogin:(NSString *)login
{
    [self saveString:login forKey:kPathLogin];
}

+ (NSString *)login
{
    return [self getStringForKey:kPathLogin];
}

+ (void)removeLogin
{
    [self deleteStringForKey:kPathLogin];
}

#pragma mark - Handler Tid

+ (void)setTid:(NSString *)tid
{
    [self saveString:tid forKey:kPathTid];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationTidWasUpdated object:nil];
}

+ (NSString *)tid
{
    return [self getStringForKey:kPathTid];
}

+ (void)removeTid
{
    [self deleteStringForKey:kPathTid];
}

#pragma mark - Handler Pin

+ (void)setPin:(NSString *)pin
{
    [self saveString:pin forKey:kPathPin];
}

+ (NSString *)pin
{
    return [self getStringForKey:kPathPin];
}

+ (void)removePin
{
    [self deleteStringForKey:kPathPin];
}

+ (void)saveHWID
{
    if (!self.getHWID.isNotEmpty)
    {
        //we don't need to modify hwid, it should be saved only once
        NSUUID *UUID = [[UIDevice currentDevice] identifierForVendor];
        [self saveString:[UUID UUIDString] forKey:kPathHWIDKey];
    }
}

+ (NSString *)getHWID
{
    return [NSString notEmptyString:[self getStringForKey:kPathHWIDKey]];
}

#pragma mark - RESET ALL KEYCHAIN

+ (void)resetKeyChain
{
    [self removeLogin];
    [self removeTid];
    [self removePin];
    [self removeAuthorization];
}

@end
