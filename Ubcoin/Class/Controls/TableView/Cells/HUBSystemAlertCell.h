//
//  HUBSystemAlertCell.h
//  Halva
//
//  Created by Alex Ostroushko on 12.03.18.
//  Copyright © 2018 uBank. All rights reserved.
//

@protocol HUBSystemAlertCellDelegate

- (void)closeSystemAlert:(UBTableViewRowData *)content;

@end


@interface HUBSystemAlertCell : UBTableViewCell

@property (weak, nonatomic) id<HUBSystemAlertCellDelegate> delegate;

- (void)setContent:(UBTableViewRowData *)content isClosed:(BOOL)isClosed;

+ (CGFloat)cellHeightForRowData:(UBTableViewRowData *)content isClosed:(BOOL)isClosed;

@end
