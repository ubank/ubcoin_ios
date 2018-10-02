//
//  UBNotificationHandler.h
//  uBank
//
//  Created by Alex Ostroushko on 29/07/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

#define ITEM_ACTIVITY @"item"

/* Push message example:
 {
    "aps":
            {
                "alert": "Message",
                "badge": 1, //optional, if need app badge push count
                "sound": "default", //optional, if need change sound
                "content-available": true, //optional, if need silent push with update info
                "mutable-content": true //optional, if need change push in app before show
            },
    "data":
            {
                "type": "pushActivity", //push type
                "activity_name": "", //activity name in app
                "id": "", //optional, if need handle activity with some id
                "landing_id": "", //optional, if need show landing with id
                "show_update_screen": 1, //optional, if need show update screen when no controller handler
                "image_url": "", //optional, if need show image from url (mutable-content = 1)
                "url": "" //optional, if need open url
            }
 }
 
 Если activity открывает вьюхи:
 1. Добавить обработку activity в метод + (BOOL)tryShowImmediatelyPush:(NSDictionary *)data
 2. Добавить обработку activity в метод + (NSURL *)urlForNotification:(NSDictionary *)data
 
 Если activity открывает контроллеры:
 1. Добавить activity в список + (NSArray *)commonActivities
 2. Добавить обработку activity в метод + (UBViewController *)controllerForActivityName:(NSString *)activity withParams:(NSDictionary *)params
 3. Если activity должен открываться только в авторизованной зоне, то его необходимо добавить в список + (NSArray *)registrationActivities
 4. Если activity должен обрабатывать параметр card_id, то его необходимо добавить в список + (NSArray *)cardIDActivities
 5. Если activity должен обрабатывать параметры, кроме id и card_id, то необходимо добавить обработку activity в метод + (NSURL *)urlForNotification:(NSDictionary *)data
*/

#define URL_SCHEME @"ubcoin://"

@interface UBCNotificationHandler : NSObject

+ (void)openURL:(NSURL *)url;
+ (BOOL)isUbcoinURLScheme:(NSURL *)url;

+ (UBViewController *)controllerForActivityName:(NSString *)activity withParams:(NSDictionary *)params;

@end
