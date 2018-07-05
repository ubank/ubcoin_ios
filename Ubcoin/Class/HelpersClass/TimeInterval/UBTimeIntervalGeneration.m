//
//  UBTimeIntervalGeneration.m
//  uBank
//
//  Created by RAVIL on 4/21/16.
//  Copyright © 2016 uBank. All rights reserved.
//

#import "UBTimeIntervalGeneration.h"

#define ARRAY_OF_TIME_INTERVAL @[@(2), @(5), @(10), @(20), @(30), @(60)]
#define DEFAULT_TIME_INTERVAL 60
#define ONE_MINUTE 60
#define TWO_MINUTE 120

@interface UBTimeIntervalGeneration ()

@property (nonatomic, copy) void (^updateBlock)(void);

@property (nonatomic) NSMutableArray *arrayOfTimeInterval;
@property (nonatomic) NSUInteger defaultInterval;

@property (nonatomic) NSInteger seconds;
@property (nonatomic) BOOL isCustomArray;

@end

@implementation UBTimeIntervalGeneration

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.seconds             = 0;
        self.arrayOfTimeInterval = [NSMutableArray arrayWithArray:ARRAY_OF_TIME_INTERVAL];
        self.defaultInterval     = DEFAULT_TIME_INTERVAL;
    }
    
    return self;
}

- (instancetype)initWithUpdateBlock:(void (^)(void))updateBlock
{
    self = [self init];
    
    if (self)
    {
        self.updateBlock = updateBlock;
    }
    
    return self;
}

- (instancetype)initWithTimeIntervals:(NSArray *)timeIntervals
                      defaultInterval:(NSUInteger)defaultInterval
                          updateBlock:(void (^)(void))updateBlock
{
    self = [self initWithUpdateBlock:updateBlock];
    
    if (self)
    {
        self.seconds = TWO_MINUTE;
        self.arrayOfTimeInterval = [timeIntervals mutableCopy];
        self.defaultInterval = defaultInterval;
        self.isCustomArray = YES;
    }
    
    return self;
}

- (instancetype)initWithTimeInterval:(NSUInteger)timeInterval
                         repeatCount:(NSUInteger)repeatCount
                     defaultInterval:(NSUInteger)defaultInterval
                         updateBlock:(void (^)(void))updateBlock
{
    NSMutableArray *arrayOfTimeIntervals = [NSMutableArray new];
    for (int i = 0; i < repeatCount; i++)
    {
        [arrayOfTimeIntervals addObject:@(timeInterval)];
    }
    
    return [self initWithTimeIntervals:arrayOfTimeIntervals
                       defaultInterval:defaultInterval
                           updateBlock:updateBlock];
}

/*
 *  Работает следующим образом :
 *      При инициализации только updateBlock - выполняются все 4 пункта, последовательно
 *      При других инициализациях - выполняются 3 и 4 пункт
 *
 *  Пункты :
 *      1) 1-ая минута каждые 5 секунд
 *      2) 2-ая минута каждые 15 секунд
 *      3) По интевалам из массива
 *      4) По дефолтному интевалу
 */
- (void)next
{
    NSUInteger minute = self.seconds / ONE_MINUTE;
    NSInteger timeInterval = self.defaultInterval;
    
    if (minute < 2)
    {
        timeInterval = (5 + (10 * minute)) % 60;
        self.seconds += timeInterval;
    }
    else if (self.arrayOfTimeInterval.count)
    {
        timeInterval = [[self.arrayOfTimeInterval firstObject] integerValue];
        [self.arrayOfTimeInterval removeObjectAtIndex:0];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf callBlock];
    });
}

- (void)callBlock
{
    if (self.updateBlock)
    {
        self.updateBlock();
    }
}

@end

