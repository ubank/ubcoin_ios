//
//  UBCSignUpController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 28.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCSignUpController.h"
#import "UBCLoginController.h"
#import "UBFloatingPlaceholderTextField.h"
#import "UBCSuccessRegistrationView.h"
#import "UBCPasswordView.h"
#import "UBCAppDelegate.h"

#import "Ubcoin-Swift.h"

@interface UBCSignUpController ()

@property (weak, nonatomic) IBOutlet HUBGeneralButton *agreementButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIStackView *fieldsStackView;
@property (weak, nonatomic) IBOutlet UBFloatingPlaceholderTextField *nameField;
@property (weak, nonatomic) IBOutlet UBFloatingPlaceholderTextField *emailField;
@property (strong, nonatomic) UBCPasswordView *passwordView;

@end

@implementation UBCSignUpController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_sign_up";
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.infoButton.titleColor = UBCColor.green;
    self.infoButton.titleLabel.font = UBFont.descFont;
    
    self.agreementButton.titleColor = [UIColor colorWithRed:129 / 255.0 green:129 / 255.0 blue:129 / 255.0 alpha:0.7];;
    self.agreementButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.agreementButton.backgroundColor = [UIColor colorWithRed:182 / 255.0 green:182 / 255.0 blue:182 / 255.0 alpha:0.2];
    
    [self setupFields];
}

- (void)setupFields
{
    self.nameField.placeholder = UBLocalizedString(@"str_name", nil);
    self.emailField.placeholder = UBLocalizedString(@"str_email", nil);
    
    self.passwordView = [UBCPasswordView loadFromXib];
    [self.fieldsStackView addArrangedSubview:self.passwordView];
}

#pragma mark - Actions

- (IBAction)didTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)showLogin
{
    [self.navigationController pushViewController:UBCLoginController.new animated:YES];
}

- (IBAction)showAgreement
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:USER_AGREEMENT_LINK]
                                       options:@{}
                             completionHandler:nil];
}

- (IBAction)requestRegistration
{
    if ([self isValidData])
    {
        [self startActivityIndicator];
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider registerUserWithFields:@{@"name": self.nameField.text,
                                                                 @"email": self.emailField.text,
                                                                 @"password": self.passwordView.text
                                                                 }
                                           withCompletionBlock:^(BOOL success)
         {
             [weakSelf stopActivityIndicator];
             if (success)
             {
                 [mainAppDelegate setupStack];
                 [UBCSuccessRegistrationView showWithEmail:weakSelf.emailField.text];
             }
         }];
    }
    else
    {
        [UBCToast showErrorToastWithMessage:@"str_incorrect_data"];
    }
}

#pragma mark -

- (BOOL)isValidData
{
    return self.nameField.text.isNotEmpty &&
    self.emailField.text.isEmail &&
    self.passwordView.isValid;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger index = [self.fieldsStackView.arrangedSubviews indexOfObject:textField];
    if (index < self.fieldsStackView.arrangedSubviews.count - 1)
    {
        UITextField *field = self.fieldsStackView.arrangedSubviews[index + 1];
        [field becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
