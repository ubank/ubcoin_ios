//
//  UBCResetPasswordController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 10.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCResetPasswordController.h"
#import "UBFloatingPlaceholderTextField.h"
#import "UBCPasswordView.h"

@interface UBCResetPasswordController ()

@property (weak, nonatomic) IBOutlet UIStackView *fieldsStackView;
@property (weak, nonatomic) IBOutlet UBFloatingPlaceholderTextField *codeField;
@property (strong, nonatomic) UBCPasswordView *passwordView;

@property (strong, nonatomic) NSString *email;

@end

@implementation UBCResetPasswordController

- (instancetype)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self)
    {
        self.email = email;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_forgot_password";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.codeField.placeholder = UBLocalizedString(@"str_confirmation_code", nil);
    
    self.passwordView = [UBCPasswordView loadFromXib];
    self.passwordView.placeholder = UBLocalizedString(@"str_new_password", nil);
    [self.fieldsStackView addArrangedSubview:self.passwordView];
}

#pragma mark - Actions

- (IBAction)didTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)resendEmail
{
    [UBCDataProvider.sharedProvider sendVerificationCodeToEmail:self.email
                                       withCompletionBlock:^(BOOL success)
     {
         if (success)
         {
             [UBCToast showToastWithMessage:@"str_email_resended"];
         }
     }];
}

- (IBAction)resetPassword
{
    if ([self isValidData])
    {
        [self startActivityIndicator];
        __weak typeof(self) weakSelf = self;
        NSDictionary *fields = @{@"code": @(self.codeField.text.integerValue),
                                 @"email": self.email,
                                 @"value": self.passwordView.text};
        [UBCDataProvider.sharedProvider resetPasswordWithParams:fields
                                            withCompletionBlock:^(BOOL success)
         {
             [weakSelf stopActivityIndicator];
             if (success)
             {
                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             }
         }];
    }
    else
    {
        [UBCToast showErrorToastWithMessage:@"str_incorrect_data"];
    }
}

- (BOOL)isValidData
{
    return self.codeField.text.integerValue >= 100000 &&
    self.codeField.text.integerValue <= 999999 &&
    self.passwordView.isValid;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.isNotEmpty && !string.isNumber)
    {
        return NO;
    }
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return text.length <= 6;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.codeField])
    {
        [self.passwordView becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
