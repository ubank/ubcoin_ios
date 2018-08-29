//
//  HUBSystemAlertCell.m
//  Halva
//
//  Created by Alex Ostroushko on 12.03.18.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBSystemAlertCell.h"

#import "Ubcoin-Swift.h"

@interface HUBSystemAlertCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet HUBLabel *desc;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIStackView *containerStackView;
@property (strong, nonatomic) UBTableViewRowData *content;

@end

@implementation HUBSystemAlertCell

+ (CGFloat)cellHeightForRowData:(UBTableViewRowData *)content isClosed:(BOOL)isClosed
{
    static HUBSystemAlertCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [HUBSystemAlertCell loadFromXib];
        sizingCell.width = SCREEN_WIDTH;
    });
    [sizingCell setContent:content isClosed:isClosed];
    [sizingCell forceLayout];
    
    if (isClosed)
    {
        UIView *header = [sizingCell.containerStackView.arrangedSubviews firstObject];
        
        return header.height + 30;
    }
    else
    {
        return sizingCell.containerStackView.height + 30;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.closeButton.tintColor = UBGRAY_COLOR;
    
    self.container.layer.cornerRadius = UBCConstant.cornerRadius;
    self.container.layer.borderColor = [RED_COLOR colorWithAlphaComponent:0.2].CGColor;
    self.container.layer.borderWidth = 1;
    
    self.title.textColor = RED_COLOR;
    self.title.font = UBFont.titleFont;
}

- (void)setContent:(UBTableViewRowData *)content isClosed:(BOOL)isClosed
{
    _content = content;
    
    self.title.text = content.title;
    self.desc.text = content.desc;
    
    self.closeButton.imageView.transform = isClosed ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
}

#pragma mark - Actions

- (IBAction)close
{
    [self.delegate closeSystemAlert:self.content];
}

@end
