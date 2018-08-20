//
//  UBCSendCoinsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 18.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSendCoinsController.h"
#import "UBCConfirmationSendCoinsController.h"

#import "Ubcoin-Swift.h"
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>

@interface UBCSendCoinsController () <UITextFieldDelegate, QRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet HUBLabel *commission;
@property (weak, nonatomic) IBOutlet HUBLabel *amountInCurrency;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *currencyActivity;

@property (strong, nonatomic) UBCPaymentDM *payment;

@end

@implementation UBCSendCoinsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"ui_button_send";
    
    self.payment = UBCPaymentDM.new;
    [self setupViews];
}

- (void)setupViews
{
    self.addressView.borderColor = UBColor.separatorColor;
    self.addressView.borderWidth = 1;
    self.addressView.cornerRadius = 6;
    
    self.addressField.textColor = UBColor.titleColor;
    self.addressField.font = UBFont.descFont;
    
    self.scanButton.tintColor = UBCColor.green;
    [self.scanButton setImage:[[UIImage imageNamed:@"wallet_qr"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    self.amountView.borderColor = UBColor.separatorColor;
    self.amountView.borderWidth = 1;
    self.amountView.cornerRadius = 6;
    
    self.amountField.textColor = UBColor.titleColor;
    self.amountField.font = UBFont.titleFont;
    
    self.amountInCurrency.textColor = UBColor.descColor;
}

- (void)updateCommissionForAmount:(NSNumber *)amount
{
    self.commission.text = @"";
    self.payment.commission = nil;
    
    self.payment.amount = amount;
    if (amount.doubleValue > 0)
    {
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider commissionForAmount:amount
                                       withCompletionBlock:^(BOOL success, NSNumber *commission)
         {
             if (success)
             {
                 weakSelf.payment.commission = commission;
                 weakSelf.commission.text = [NSString stringWithFormat:@"%@: %@", UBLocalizedString(@"", nil), commission.priceString];
             }
         }];
    }
}

- (void)convertUBCForAmount:(NSNumber *)amount
{
    self.amountInCurrency.text = @"";
    
    if (amount.doubleValue > 0)
    {
        [self.currencyActivity startAnimating];
        
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider convertFromCurrency:@"UBC"
                                                 toCurrency:@"USD"
                                                 withAmount:amount
                                        withCompletionBlock:^(BOOL success, NSNumber *amountInCurrency)
         {
             [weakSelf.currencyActivity stopAnimating];
             if (success)
             {
                 weakSelf.amountInCurrency.text = amountInCurrency.priceString;
             }
         }];
    }
}

#pragma mark - Actions

- (IBAction)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)scanQR
{
    if (![HUBPermissions checkPermission:HUBPermissionValueCamera])
    {
        return;
    }
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    QRCodeReaderViewController *controller = [QRCodeReaderViewController readerWithCancelButtonTitle:UBLocalizedString(@"ui_button_cancel", nil) codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)next
{
    if (self.payment.valid)
    {
        UBCConfirmationSendCoinsController *controller = [UBCConfirmationSendCoinsController.alloc initWithPayment:self.payment];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [UBCToast showErrorToastWithMessage:@"str_incorrect_data"];
    }
}

#pragma mark - QRCodeReaderDelegate

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    self.addressField.text = result;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.amountField])
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSNumber *amount = @(text.doubleValue);
        [self convertUBCForAmount:amount];
        [self updateCommissionForAmount:amount];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.addressField])
    {
        [self.amountField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
