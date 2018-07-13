//
//  UBCAuthorDM.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 08.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCAuthorDM : NSObject

@property (readonly, nonatomic) NSString *ID;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *avatarURL;
@property (readonly, nonatomic) NSNumber *rating;
@property (readonly, nonatomic) NSUInteger itemsCount;
@property (readonly, nonatomic) NSUInteger reviewsCount;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
