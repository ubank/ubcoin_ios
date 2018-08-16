//
//  UBDefaultTableView.m
//  Halva
//
//  Created by Alex Ostroushko on 22.05.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "UBDefaultTableView.h"
#import "UBWaitCell.h"
#import "UBSwitchTableViewCell.h"

#import "Ubcoin-Swift.h"

@interface UBDefaultTableView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *sections;

@end


@implementation UBDefaultTableView

#pragma mark - Init Methods

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.backgroundColor = UBColor.backgroundColor;
    self.rowHeight = UBCConstant.cellHeight;
    
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBSectionHeaderView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(UBSectionHeaderView.class)];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(UBWaitCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UBWaitCell.class)];
}

#pragma mark - Data Methods

- (void)updateWithSectionsData:(NSArray<UBTableViewSectionData *> *)sections
{
    self.sections = sections;
    
    [self reloadData];
}

- (void)updateWithRowsData:(NSArray<UBTableViewRowData *> *)rows
{
    UBTableViewSectionData *section = UBTableViewSectionData.new;
    section.headerHeight = SEPARATOR_HEIGHT;
    section.rows = rows;
    [self updateWithSectionsData:@[section]];
}

- (UBTableViewRowData *)rowDataForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.sections.count)
    {
        UBTableViewSectionData *sectionData = self.sections[indexPath.section];
        if (indexPath.row < sectionData.rows.count)
        {
            return sectionData.rows[indexPath.row];
        }
    }
    
    return nil;
}

- (Class)classForRowData:(UBTableViewRowData *)rowData
{
    if (!rowData.className.isNotEmpty)
    {
        return UBDefaultTableViewCell.class;
    }
    Class cellClass = NSClassFromString(rowData.className);
    if (![cellClass isSubclassOfClass:UBDefaultTableViewCell.class])
    {
        return UBDefaultTableViewCell.class;
    }
    
    return cellClass;
}

- (BOOL)isWaitCellIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section >= self.sections.count;
}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.sections.count > 0)
    {
        return self.sections.count + self.canLoadMore;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        return sectionData.rows.count;
    }

    return self.canLoadMore;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        return CELL_HEIGHT;
    }
    
    UBTableViewRowData *rowData = [self rowDataForIndexPath:indexPath];
    if (rowData.height > 0)
    {
        return rowData.height;
    }
    else
    {
        Class cellClass = [self classForRowData:rowData];
        
        UBDefaultTableViewCell *cell = [cellClass sizingCell];
        
        if ([self.actionDelegate respondsToSelector:@selector(prepareCell:forData:)])
        {
            [self.actionDelegate prepareCell:cell forData:rowData];
        }
        
        cell.rowData = rowData;
        
        if ([self.actionDelegate respondsToSelector:@selector(layoutCell:forData:indexPath:)])
        {
            [self.actionDelegate layoutCell:cell forData:rowData indexPath:indexPath];
        }
        
        return cell.cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        if ([self.actionDelegate respondsToSelector:@selector(updatePagination)])
        {
            [self.actionDelegate updatePagination];
        }
        
        return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UBWaitCell.class)];
    }
    
    UBTableViewRowData *rowData = [self rowDataForIndexPath:indexPath];
    
    Class cellClass = [self classForRowData:rowData];
    
    UBDefaultTableViewCell *cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    if (!cell)
    {
        cell = [cellClass.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
        
        if ([self.actionDelegate respondsToSelector:@selector(prepareCell:forData:)])
        {
            [self.actionDelegate prepareCell:cell forData:rowData];
        }
    }
    
    cell.showBottomSeparator = ![self isLastIndexPathInSection:indexPath];
    
    cell.rowData = rowData;
    
    if ([self.actionDelegate respondsToSelector:@selector(layoutCell:forData:indexPath:)])
    {
        [self.actionDelegate layoutCell:cell forData:rowData indexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        return;
    }
    
    UBTableViewRowData *rowData = [self rowDataForIndexPath:indexPath];
    if (!rowData.isDisabled && [self.actionDelegate respondsToSelector:@selector(didSelectData:indexPath:)])
    {
        [self.actionDelegate didSelectData:rowData indexPath:indexPath];
    }
}

#pragma mark - Edit Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isWaitCellIndexPath:indexPath])
    {
        return NO;
    }
    
    UBTableViewRowData *rowData = [self rowDataForIndexPath:indexPath];
    
    return rowData.isEditable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UBTableViewRowData *rowData = [self rowDataForIndexPath:indexPath];
    
    if ([self.actionDelegate respondsToSelector:@selector(editData:commitEditingStyle:indexPath:)])
    {
        [self.actionDelegate editData:rowData commitEditingStyle:editingStyle indexPath:indexPath];
    }
}

#pragma mark - Header Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        NSString *header = [self tableView:self titleForHeaderInSection:section];
        if (header.isNotEmpty || sectionData.headerHeight <= SEPARATOR_HEIGHT)
        {
            return sectionData.headerHeight;
        }
    }
    
    return ZERO_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        return sectionData.headerTitle;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        UBSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(UBSectionHeaderView.class)];
        
        headerView.title.text = [self tableView:tableView titleForHeaderInSection:section];
        headerView.background.backgroundColor = sectionData.headerColor ?: UBColor.backgroundColor;
        
        if ([self.actionDelegate respondsToSelector:@selector(prepareHeaderView:)])
        {
            [self.actionDelegate prepareHeaderView:headerView];
        }
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - Footer Methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        NSString *footer = [self tableView:self titleForFooterInSection:section];
        if (footer.isNotEmpty)
        {
            return [footer calculateSizeWithFont:UBFont.titleFont constrainedToSize:CGSizeMake(self.width, MAXFLOAT)].height + 10;
        }
        else if (sectionData.footerHeight <= SEPARATOR_HEIGHT)
        {
            return sectionData.footerHeight;
        }
    }
    
    return ZERO_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        return sectionData.footerTitle;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.sections.count > section)
    {
        UBTableViewSectionData *sectionData = self.sections[section];
        
        UBSectionHeaderView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(UBSectionHeaderView.class)];
        
        footerView.title.text = [self tableView:tableView titleForFooterInSection:section];
        footerView.title.font = UBFont.descFont;
        footerView.title.textColor = UBColor.descColor;
        footerView.background.backgroundColor = sectionData.footerColor ?: UBColor.backgroundColor;
        
        if ([self.actionDelegate respondsToSelector:@selector(prepareFooterView:)])
        {
            [self.actionDelegate prepareFooterView:footerView];
        }
        
        return footerView;
    }
    
    return nil;
}

@end
