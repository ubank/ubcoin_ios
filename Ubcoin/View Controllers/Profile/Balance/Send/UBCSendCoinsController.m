//
//  UBCSendCoinsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 18.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSendCoinsController.h"
#import "UBCConfirmationSendCoinsController.h"

@interface UBCSendCoinsController ()

@property (strong, nonatomic) UBCPaymentDM *payment;

@end

@implementation UBCSendCoinsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ui_button_send";
}

#pragma mark - Actions

- (IBAction)next
{
    if (self.payment.valid)
    {
        UBCConfirmationSendCoinsController *controller = [UBCConfirmationSendCoinsController.alloc initWithPayment:self.payment];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
