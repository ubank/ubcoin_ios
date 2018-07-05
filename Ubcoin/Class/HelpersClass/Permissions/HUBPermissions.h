//
//  HUBPermissions.h
//  Halva
//
//  Created by Sergey Minakov on 02.07.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *HUBPermissionValue NS_STRING_ENUM;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT HUBPermissionValue HUBPermissionValueCamera;
FOUNDATION_EXPORT HUBPermissionValue HUBPermissionValueLocation;

@interface HUBPermissions : NSObject

+ (BOOL)checkPermission:(HUBPermissionValue)value;
+ (BOOL)checkPermissions:(NSArray<HUBPermissionValue> *)values;

@end

NS_ASSUME_NONNULL_END
