//
//  UBCTopupView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 19.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBCTopupView : UBTopWindow

- (void)setupWithQRCodeURL:(NSString *)qrCodeURL address:(NSString *)address;

@end
