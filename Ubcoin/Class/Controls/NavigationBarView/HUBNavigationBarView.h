//
//  HUBStoresNavigationBarView.h
//  Halva
//
//  Created by Александр Макшов on 19.02.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

@interface HUBNavigationBarView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UBButton *backButton;

@property (assign, nonatomic) BOOL isTransparent;

@property (copy, nonatomic) void (^exitActionBlock)(void);

- (void)handleScrollOffset:(CGFloat)offset;

@end
