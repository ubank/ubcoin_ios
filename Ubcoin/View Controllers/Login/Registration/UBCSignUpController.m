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

    self.title = @"Sign Up";
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.infoButton.titleColor = UBCColor.green;
    self.infoButton.titleLabel.font = UBFont.descFont;
    
    [self setupFields];
}

- (void)setupFields
{
    self.nameField.placeholder = @"Name";
    self.emailField.placeholder = @"Email";
    
    self.passwordView = [UBCPasswordView loadFromXib];
    [self.fieldsStackView addArrangedSubview:self.passwordView];
}

- (IBAction)didTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)showLogin
{
    [self.navigationController pushViewController:UBCLoginController.new animated:YES];
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
        [UBCToast showErrorToastWithMessage:@"Incorrect Data"];
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
