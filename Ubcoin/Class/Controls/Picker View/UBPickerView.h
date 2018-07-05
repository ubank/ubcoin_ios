//
//  UBPickerView.h
//  uBank
//
//  Created by ravil on 5/16/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

typedef enum
{
    UBPickerTypeDate,
    UBPickerTypeMonthYear
} UBPickerType;

typedef void (^doneBlock)(NSDate *date);
typedef void (^cancelBlock)(void);

@interface UBPickerView : UIView

+ (void)showPickerWithType:(UBPickerType)type
                      date:(NSDate *)date
                   minDate:(NSDate *)minDate
                   maxDate:(NSDate *)maxDate
                 doneBlock:(doneBlock)doneBlock
               cancelBlock:(cancelBlock)cancelBlock;

@end
