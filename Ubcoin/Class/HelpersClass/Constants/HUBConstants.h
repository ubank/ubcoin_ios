//
//  HUBConstants.h
//  uBank
//
//  Created by Yauheni Zinchanka on 4/5/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

#define URL_SCHEME @"halva://"
#define BUNDLE_ID [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define DATABASE_NAME @"Halva.sqlite"
#define CATALOG_FILE_NAME @"Catalog"

#define DEFAULT_HEADER_FONT [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold]
#define HUGE_TITLE_FONT [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold]

#define BROWN_COLOR [UIColor colorWithHexString:@"D6584D"]
#define RED_COLOR [UIColor colorWithHexString:@"FF4E50"]
#define UBLACK_COLOR [UIColor colorWithHexString:@"2A2A2A"]
#define UBGRAY_COLOR [UIColor colorWithHexString:@"808080"]
#define LIGHT_GRAY_COLOR [UIColor colorWithHexString:@"EEEEEE"]
#define LIGHT_GRAY_COLOR2 [UIColor colorWithHexString:@"DCDCDC"]
#define BONUS_BACKGROUND_COLOR [UIColor colorWithHexString:@"#FFEBA1"]
#define SUPPORT_COLOR [UIColor colorWithHexString:@"25EE4A"]
#define CHATBANK_COLOR [UIColor colorWithHexString:@"2970D3"]
#define QUESTIONNAIRE_ERROR_COLOR [UIColor colorWithHexString:@"F26464"]
#define PAYMENT_NORMAL_STATUS_COLOR [UIColor colorWithHexString:@"61C798"]
#define PAYMENT_CRITICAL_STATUS_COLOR [UIColor colorWithHexString:@"F57C00"]
#define BLUE_GRADIENT_COLORS @[(id)[UIColor colorWithHexString:@"3D9FFF"].CGColor, (id)[UIColor colorWithHexString:@"595AD3"].CGColor]

#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
//#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif

#define ACTION_BUTTON_HEIGHT 50
#define CARD_SIZE CGSizeMake(58, 40)

#define DEFAULT_INSET 15

#define DEFAULT_CORNER_RADIUS 8
#define BIG_CORNER_RADIUS 14

#define SMALL_CELL_HEIGHT 25
#define CELL_HEIGHT 45
#define DEFAULT_CELL_HEIGHT 75

// Notification
static NSString * const kNotificationQuitFromApplication = @"kNotificationQuitFromApp";
static NSString * const kNotificationSignatureNotValid = @"kNotificationSignatureNotValid";
static NSString * const kNotificationUserBlocked = @"kNotificationUserBlochedByHWID";
static NSString * const kNotificationTidWasUpdated = @"User tid was updated";

static NSString * const kNotificationPullToMiddleState = @"pullInfoViewToMiddle";
static NSString * const kNotificationHideToBottomState = @"pullInfoViewToHideInBottom";
static NSString * const kNotificationPullToNearestState = @"pullInfoViewToNearest";
static NSString * const kNotificationPullUpdateSize = @"pullInfoViewUpdateSize";
static NSString * const kNotificationImmediatelyPushCalled = @"kNotificationImmediatelyPushCalled";
