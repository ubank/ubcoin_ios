//
//  UBTimeIntervalGeneration.h
//  uBank
//
//  Created by RAVIL on 4/21/16.
//  Copyright © 2016 uBank. All rights reserved.
//

@interface UBTimeIntervalGeneration : NSObject

- (instancetype)initWithUpdateBlock:(void (^)(void))updateBlock;

- (instancetype)initWithTimeIntervals:(NSArray *)timeIntervals
                      defaultInterval:(NSUInteger)defaultInterval
                          updateBlock:(void (^)(void))updateBlock;

- (instancetype)initWithTimeInterval:(NSUInteger)timeInterval
                         repeatCount:(NSUInteger)repeatCount
                     defaultInterval:(NSUInteger)defaultInterval
                         updateBlock:(void (^)(void))updateBlock;
- (void)next;

@end
