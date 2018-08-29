//
//  UBCConfirmationSendCoinsController.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 18.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBViewController.h"
#import "UBCPaymentDM.h"

@interface UBCConfirmationSendCoinsController : UBViewController

- (instancetype)initWithPayment:(UBCPaymentDM *)payment;

@end
