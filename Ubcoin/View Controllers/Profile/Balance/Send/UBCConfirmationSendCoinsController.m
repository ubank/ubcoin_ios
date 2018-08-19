//
//  UBCConfirmationSendCoinsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 18.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCConfirmationSendCoinsController.h"

@interface UBCConfirmationSendCoinsController ()

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;

@property (strong, nonatomic) UBCPaymentDM *payment;

@end

@implementation UBCConfirmationSendCoinsController

- (instancetype)initWithPayment:(UBCPaymentDM *)payment
{
    self = [super init];
    if (self)
    {
        self.payment = payment;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_info";
    
    [self.tableView updateWithRowsData:self.payment.rowsData];
}

#pragma mark - Actions

- (IBAction)send
{
    [self startActivityIndicator];
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider sendCoins:self.payment.amount
                                    toAddress:self.payment.address
                          withCompletionBlock:^(BOOL success, NSNumber *result, NSString *message)
     {
         [weakSelf stopActivityIndicator];
         if (success)
         {
             if ([result isEqualToNumber:@0])
             {
                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             }
             else if (message.isNotEmpty)
             {
                 [UBCToast showErrorToastWithMessage:message];
             }
         }
     }];
}

#pragma mark - UBDefaultTableViewDelegate

- (void)prepareCell:(UBDefaultTableViewCell *)cell forData:(UBTableViewRowData *)data
{
    cell.title.textColor = UBColor.descColor;
    cell.title.font = UBFont.descFont;
    
    cell.desc.textColor = UBColor.titleColor;
    cell.desc.font = UBFont.titleFont;
}

@end
