//
//  UBCTopupView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 19.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCTopupView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UBCTopupView ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCode;
@property (weak, nonatomic) IBOutlet UITextView *address;

@end

@implementation UBCTopupView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.address.backgroundColor = UBColor.backgroundColor;
    self.address.cornerRadius = 4.5;
    self.address.font = UBFont.descFont;
    self.address.textColor = UBColor.titleColor;
}

- (void)setupWithQRCodeURL:(NSString *)qrCodeURL address:(NSString *)address
{
    self.address.text = address;
    [self.qrCode sd_setImageWithURL:[NSURL URLWithString:qrCodeURL]];
}

@end
