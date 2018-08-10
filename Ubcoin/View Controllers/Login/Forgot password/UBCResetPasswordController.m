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
    [UBCDataProvider.sharedProvider resendPasswordForEmail:self.email
                                       withCompletionBlock:^(BOOL success)
     {
         if (success)
         {
             [UBCToast showToastWithMessage:@"str_email_resended"];
         }
     }];
}

#pragma mark - UITextFieldDelegate

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
