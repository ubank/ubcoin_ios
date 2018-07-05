//
//  UBAlertTableView.h
//  uBank
//
//  Created by ravil on 7/9/13.
//  Copyright (c) 2013 uBank. All rights reserved.
//

@interface UBAlertTableView : UIView

@property (copy, nonatomic) void (^dataSelected)(UBTableViewRowData *rowData);

+ (instancetype)showWithContent:(NSArray<UBTableViewSectionData *> *)content title:(NSString *)title;

@end
