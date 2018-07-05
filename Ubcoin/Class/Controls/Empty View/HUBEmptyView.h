//
//  HUBEmptyView.h
//  uBank
//
//  Created by Alex Ostroushko on 25.07.17.
//  Copyright © 2017 uBank. All rights reserved.
//

@interface HUBEmptyView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *firstButton;
@property (weak, nonatomic) IBOutlet HUBGeneralButton *secondButton;

@property (copy, nonatomic) void (^firstActionBlock)(void);
@property (copy, nonatomic) void (^secondActionBlock)(void);

@end
