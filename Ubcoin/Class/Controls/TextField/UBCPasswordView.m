//
//  UBCPasswordView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 01.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCPasswordView.h"
#import "DBZxcvbn.h"
#import "UBFloatingPlaceholderTextField.h"

@interface UBCPasswordView() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UBFloatingPlaceholderTextField *field;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (strong, nonatomic) DBZxcvbn *scoring;

@end

@implementation UBCPasswordView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    [self setHeightConstraintWithValue:50];
    
    self.scoring = DBZxcvbn.new;
    self.info.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.field.line.hidden = YES;
    
    UIView *separator = UIView.new;
    separator.backgroundColor = UBColor.separatorColor;
    [self addSubview:separator];
    
    [separator setHeightConstraintWithValue:1.5];
    [self setLeadingConstraintToSubview:separator withValue:0];
    [self setTrailingConstraintToSubview:separator withValue:0];
    [self setBottomConstraintToSubview:separator withValue:0];
}

- (void)applyScore:(NSUInteger)score
{
    switch (score)
    {
        case 1:
        {
            UIColor *color = [UIColor colorWithHexString:@"e33f5e"];
            self.field.textColor = color;
            self.info.textColor = color;
            self.info.text = @"Weak";
        }
            break;
        
        case 2:
        {
            UIColor *color = [UIColor colorWithHexString:@"3f98e3"];
            self.field.textColor = color;
            self.info.textColor = color;
            self.info.text = @"Normal";
        }
            break;
        
        case 3:
        case 4:
        {
            UIColor *color = [UIColor colorWithHexString:@"32bb8f"];
            self.field.textColor = color;
            self.info.textColor = color;
            self.info.text = @"Strong";
        }
            break;
        
        default:
        {
            UIColor *color = UBColor.titleColor;
            self.field.textColor = color;
            self.info.text = @"";
        }
            break;
    }
}

#pragma mark -

- (BOOL)becomeFirstResponder
{
    return [self.field becomeFirstResponder];
}

- (BOOL)isValid
{
    return self.field.text.isNotEmpty;
}

- (NSString *)text
{
    return self.field.text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *password = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    DBResult *score = [self.scoring passwordStrength:password];
    [self applyScore:score.score];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

@end
