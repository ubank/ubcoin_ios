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
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UITextField *amountField;

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
