//
//  UBSwitchTableViewCell.m
//  Halva
//
//  Created by Александр Макшов on 19.06.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "UBSwitchTableViewCell.h"

@interface UBSwitchTableViewCell ()

@property (strong, nonatomic) UISwitch *switcher;

@end

@implementation UBSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setupSwitcher];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSwitcher];
}

- (void)setupSwitcher
{
    self.switcher = UISwitch.new;
    [self.switcher addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchToggled:(UISwitch *)switcher
{
    if (self.switchAction)
    {
        self.switchAction(switcher.isOn);
    }
}

- (void)setRowData:(UBTableViewRowData *)rowData
{
    [super setRowData:rowData];
    
    self.accessoryView = self.switcher;
    self.switcher.on = rowData.isSelected;
}

@end
