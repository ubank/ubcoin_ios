//
//  UBCGoodDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 06.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCGoodDM : NSObject

@property (readonly, nonatomic) NSString *itemID;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) NSString *desc;
@property (readonly, nonatomic) NSString *locationText;
@property (readonly, nonatomic) NSNumber *price;
@property (readonly, nonatomic) NSDate *creationDate;
@property (readonly, nonatomic) BOOL isFavorite;
@property (readonly, nonatomic) NSArray *images;

//@property (readonly, nonatomic) UBCUserDM *seller;
//@property (readonly, nonatomic) UBCCategoryDM *category;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
