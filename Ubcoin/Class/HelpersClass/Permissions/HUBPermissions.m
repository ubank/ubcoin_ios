//
//  HUBPermissions.m
//  Halva
//
//  Created by Sergey Minakov on 02.07.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBPermissions.h"

HUBPermissionValue HUBPermissionValueCamera = @"HUBPermissionValueCamera";
HUBPermissionValue HUBPermissionValueLocation = @"HUBPermissionValueLocation";

@implementation HUBPermissions

+ (BOOL)checkPermission:(HUBPermissionValue)value
{
    BOOL result = YES;
    NSString *noPermissionMessage = nil;
    
    if ([value isEqualToString:HUBPermissionValueCamera])
    {
        switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
        {
            case AVAuthorizationStatusAuthorized:
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                result = NO;
                noPermissionMessage = @"ui_alert_message_error_no_camera_access";
                break;
            case AVAuthorizationStatusNotDetermined:
                result = NO;
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL _){ }];
                break;
        }
    }
    else if ([value isEqualToString:HUBPermissionValueLocation])
    {
        switch (CLLocationManager.authorizationStatus)
        {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                result = NO;
                noPermissionMessage = @"ui_alert_message_geo_error";
                break;
            case kCLAuthorizationStatusNotDetermined:
                result = NO;
                [[CLLocationManager new] requestWhenInUseAuthorization];
                break;
        }
    }
    
    if (noPermissionMessage)
    {
        [UBAlert showAlertToEnablePermissionsWithMessage:noPermissionMessage];
    }
    
    return result;
}

+ (BOOL)checkPermissions:(NSArray<HUBPermissionValue> *)values
{
    for (HUBPermissionValue value in values)
    {
        if (![self checkPermission:value])
        {
            return NO;
        }
    }
    
    return YES;
}

@end
