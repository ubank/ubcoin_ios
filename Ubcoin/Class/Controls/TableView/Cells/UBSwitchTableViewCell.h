//
//  UBSwitchTableViewCell.h
//  Halva
//
//  Created by Александр Макшов on 19.06.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

@interface UBSwitchTableViewCell : UBDefaultTableViewCell

@property (copy, nonatomic) void (^switchAction)(BOOL isEnabled);

- (void)setRowData:(UBTableViewRowData *)rowData;

@end
