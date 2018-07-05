//
//  UBAlertWindow.h
//  Halva
//
//  Created by Aidar on 16.04.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

@interface UBAlertWindow : UBTopWindow

typedef void (^additionalActionBlock)(NSInteger index);

+ (instancetype)showAlertWindowWithTitle:(NSString *)title
                                    desc:(NSString *)desc
                                   image:(UIImage *)image;

+ (instancetype)showAlertWindowWithTitle:(NSString *)title
                                    desc:(NSString *)desc
                                   image:(UIImage *)image
                        buttonApplyTitle:(NSString *)buttonApplyTitle
                       buttonCancelTitle:(NSString *)buttonCancelTitle
                     withCompletionBlock:(additionalActionBlock)completion;

@end
