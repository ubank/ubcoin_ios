//
//  UBKeyChain.h
//  uBank
//
//  Created by Yauheni Zinchanka on 5/13/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

@interface UBKeyChain : NSObject

// Authorization
// Используем авторизацию пока пользователь не зарегистрируется.
// Используется в тех же местах, но имеет другое смысловое значение,
// по наличию авторизации будем определять статус пользователя в системе
@property (class, strong, nonatomic) NSString *authorization;

@property (class, strong, nonatomic) NSString *login;
@property (class, strong, nonatomic) NSString *tid;
@property (class, strong, nonatomic) NSString *pin;
@property (class, strong, nonatomic) NSString *publicKey;
@property (class, strong, nonatomic) NSString *privateKey;

+ (void)saveHWID;
+ (NSString *)getHWID;

+ (void)removeAuthorization;
+ (void)resetKeyChain;
+ (void)transferKeychain;

@end
