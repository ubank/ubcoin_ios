//
//  UBExpandableTableViewSectionHeader.h
//  uBank
//
//  Created by Александр Макшов on 01.08.17.
//  Copyright © 2017 uBank. All rights reserved.
//

@interface UBExpandableTableViewSectionHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) UBTableViewExpandableSectionData *sectionData;

@property (copy, nonatomic) void(^actionBlock)(UBExpandableTableViewSectionHeader *header);

@property (weak, nonatomic) IBOutlet HUBLabel *mainLabel;
@property (weak, nonatomic) IBOutlet HUBLabel *detailsLabel;

- (void)moveArrowForStateOpened:(BOOL)isOpened;

@end
