//
//  UBCLoginController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 05.07.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCLoginController.h"

#import "Ubcoin-Swift.h"

@interface UBCLoginController ()

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UBCTextField *loginField;
@property (strong, nonatomic) UBCTextField *passwordField;

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
    self.infoButton.titleColor = UBCColor.green;
    self.infoButton.titleLabel.font = UBFont.descFont;
    
    [self setupFields];
}

- (void)setupFields
{
    self.loginField = UBCTextField.new;
    self.loginField.placeholder = @"Email";
    [self.view addSubview:self.loginField];
    
    [self.view setTopConstraintToSubview:self.loginField withValue:50];
    [self.view setLeadingConstraintToSubview:self.loginField withValue:15];
    [self.view setTrailingConstraintToSubview:self.loginField withValue:-15];
    
    self.passwordField = UBCTextField.new;
    self.passwordField.placeholder = @"Password";
    [self.view addSubview:self.passwordField];
    
    [self.loginField setTopConstraintToSubview:self.passwordField withValue:20];
    [self.view setLeadingConstraintToSubview:self.passwordField withValue:15];
    [self.view setTrailingConstraintToSubview:self.passwordField withValue:-15];
}

#pragma mark - Actions

- (IBAction)didTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)showRegistration
{
    
}

- (IBAction)login
{
    
}

@end
