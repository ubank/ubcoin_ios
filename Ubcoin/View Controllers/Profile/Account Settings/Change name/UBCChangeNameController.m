//
//  UBCChangeNameController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 16.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCChangeNameController.h"
#import "UBFloatingPlaceholderTextField.h"
#import "UBCUserDM.h"

@interface UBCChangeNameController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation UBCChangeNameController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_name";
    self.navigationContainer.rightTitle = UBLocalizedString(@"ui_button_done", nil);
    
    UBCUserDM *user = [UBCUserDM loadProfile];
    self.nameField.text = user.name;
    self.nameField.font = UBFont.titleFont;
    self.nameField.textColor = UBColor.titleColor;
}

#pragma mark - Actions

- (void)rightBarButtonClick:(id)sender
{
    [self.view endEditing:YES];
    if (self.nameField.text.isNotEmpty)
    {
        [self startActivityIndicator];
        __weak typeof(self) weakSelf = self;
        [UBCDataProvider.sharedProvider updateUserFields:@{NAME_KEY: self.nameField.text}
                                     withCompletionBlock:^(BOOL success)
         {
             [weakSelf stopActivityIndicator];
             if (success)
             {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self rightBarButtonClick:nil];
    
    return YES;
}

@end
