//
//  UBCLoginController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCLoginController.h"
#import "UBCSignUpController.h"
#import "UBFloatingPlaceholderTextField.h"

#import "Ubcoin-Swift.h"

@interface UBCLoginController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UBFloatingPlaceholderTextField *loginField;
@property (strong, nonatomic) UBFloatingPlaceholderTextField *passwordField;

@end

@implementation UBCLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Log In";
    
    [self setupViews];
}

- (void)setupViews
{
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.infoButton.titleColor = UBCColor.green;
    self.infoButton.titleLabel.font = UBFont.descFont;
    
    [self setupFields];
    
    UIButton *forgotButton = UIButton.new;
    [forgotButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    forgotButton.titleColor = UBCColor.green;
    forgotButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [forgotButton addTarget:self action:@selector(showForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotButton];
    
    [forgotButton setHeightConstraintWithValue:40];
    [self.view setLeadingConstraintToSubview:forgotButton withValue:15];
    [self.view setVerticalSpacingBeweenSubview:self.passwordField
                                    andSubview:forgotButton
                                     withValue:0];
}

- (void)setupFields
{
    self.loginField = UBFloatingPlaceholderTextField.new;
    [self.loginField setup];
    self.loginField.delegate = self;
    self.loginField.placeholder = @"Email";
    self.loginField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.loginField];
    
    [self.loginField setHeightConstraintWithValue:50];
    [self.view setTopConstraintToSubview:self.loginField withValue:80];
    [self.view setLeadingConstraintToSubview:self.loginField withValue:15];
    [self.view setTrailingConstraintToSubview:self.loginField withValue:-15];
    
    self.passwordField = UBFloatingPlaceholderTextField.new;
    [self.passwordField setup];
    self.passwordField.delegate = self;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    [self.passwordField setHeightConstraintWithValue:50];
    [self.view setLeadingConstraintToSubview:self.passwordField withValue:15];
    [self.view setTrailingConstraintToSubview:self.passwordField withValue:-15];
    [self.view setVerticalSpacingBeweenSubview:self.loginField
                                    andSubview:self.passwordField
                                     withValue:10];
}

#pragma mark - Actions

- (IBAction)didTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)showForgotPassword
{
    [self.navigationController pushViewController:UBCForgotPasswordController.new animated:YES];
}

- (IBAction)showRegistration
{
    [self.navigationController pushViewController:UBCSignUpController.new animated:YES];
}

- (IBAction)login
{
    if ([self isValidData])
    {
        [self startActivityIndicator];
        [UBCDataProvider.sharedProvider loginWithEmail:self.loginField.text
                                              password:self.passwordField.text
                                   withCompletionBlock:^(BOOL success)
         {
             if (success)
             {
                 
             }
             else
             {
                 [UBCToast showErrorToastWithMessage:@"Incorrect Email or Password"];
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
    return self.loginField.text.isEmail &&
    self.passwordField.text.isNotEmpty;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.loginField])
    {
        [self.passwordField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
