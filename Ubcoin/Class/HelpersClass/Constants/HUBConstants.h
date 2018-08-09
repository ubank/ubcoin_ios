//
//  HUBConstants.h
//  uBank
//
//  Created by Yauheni Zinchanka on 4/5/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

#define BUNDLE_ID [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"]

#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
//#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif

#define CELL_HEIGHT 65

#define BROWN_COLOR [UIColor colorWithHexString:@"D6584D"]
#define RED_COLOR [UIColor colorWithHexString:@"FF4E50"]
#define UBLACK_COLOR UBColor.titleColor
#define UBGRAY_COLOR UBColor.descColor
#define LIGHT_GRAY_COLOR [UIColor colorWithHexString:@"EEEEEE"]
#define LIGHT_GRAY_COLOR2 [UIColor colorWithHexString:@"DCDCDC"]

#define DEFAULT_HEADER_FONT [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold]

static NSString *const USER_AGREEMENT_LINK = @"https://ubcoin.io/user-agreement";
