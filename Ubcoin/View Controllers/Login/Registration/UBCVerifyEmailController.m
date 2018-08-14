//
//  UBCVerifyEmailController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 07.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCVerifyEmailController.h"
#import "UBCSuccessRegistrationView.h"
#import "UBCAppDelegate.h"

#import "Ubcoin-Swift.h"

@interface UBCVerifyEmailController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet HUBLabel *info;
@property (weak, nonatomic) IBOutlet UBFloatingPlaceholderTextField *code;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *sendButton;
@property (strong ,nonatomic) NSDictionary *fields;

@end

@implementation UBCVerifyEmailController

- (instancetype)initWithFields:(NSDictionary *)fields
{
    self = [super init];
    if (self)
    {
        self.fields = fields;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_confirmation";
    self.view.backgroundColor = UIColor.whiteColor;
    self.info.textColor = UBColor.titleColor;
    self.code.placeholder = UBLocalizedString(@"str_code", nil);
    
    [self setupInfoTextWithEmail:self.fields[@"email"]];
}

- (void)setupInfoTextWithEmail:(NSString *)email
{
    if (email)
    {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:UBLocalizedString(@"str_we_sent_verification_letter", nil)];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:email attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold]}]];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:UBLocalizedString(@"str_enter_code_to_confirm_your_email", nil)]];
        self.info.attributedText = text;
    }
}

#pragma mark -

- (IBAction)didTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)verifyEmail
{
    [self startActivityIndicator];
    __weak typeof(self) weakSelf = self;
    [UBCDataProvider.sharedProvider verifyEmail:self.fields[@"email"]
                                       withCode:self.code.text
                            withCompletionBlock:^(BOOL success)
     {
         [weakSelf stopActivityIndicator];
         if (success)
         {
             [mainAppDelegate setupStack];
             [UBCSuccessRegistrationView show];
         }
         else
         {
             [UBCToast showErrorToastWithMessage:@"str_wrong_code"];
         }
     }];
}

- (IBAction)resendEmail
{
    [UBCDataProvider.sharedProvider registerUserWithFields:self.fields
                                       withCompletionBlock:^(BOOL success)
     {
         if (success)
         {
             [UBCToast showToastWithMessage:@"str_email_resended"];
         }
     }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.isNotEmpty && !string.isNumber)
    {
        return NO;
    }
    
    NSString *code = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.sendButton.enabled = code.length == 6;
    return code.length <= 6;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
