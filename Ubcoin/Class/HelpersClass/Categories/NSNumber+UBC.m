//
//  NSNumber+UBC.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 13.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "NSNumber+UBC.h"

@implementation NSNumber (UBC)

- (NSString *)coinsPriceString
{
    return [self priceMinimumDigits:4 maximumDigits:4];
}

- (NSString *)deliveryPriceString
{
    return [self priceMinimumDigits:0 maximumDigits:20];
}


- (NSString *) priceMinimumDigits:(int) min maximumDigits:(int) max
{
    NSNumberFormatter *format = NSNumberFormatter.new;
    
    format.groupingSize = 3;
    format.groupingSeparator = @" ";
    format.locale = UBLocal.shared.locale;
//    format.minimumFractionDigits = self.doubleValue == self.integerValue ? 0 : 4;
    format.minimumFractionDigits = min;
    format.maximumFractionDigits = max;
    format.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [format stringFromNumber:self];
}

@end
