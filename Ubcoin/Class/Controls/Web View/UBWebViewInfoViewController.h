//
//  UBWebViewInfoViewController.h
//  uBank
//
//  Created by Alex Ostroushko on 05/03/14.
//  Copyright (c) 2014 uBank. All rights reserved.
//

@protocol UBWebViewInfoViewControllerDelegate <NSObject>

- (BOOL)needHandleURL:(NSURL *)url;

@end


@interface UBWebViewInfoViewController : UBDefaultController

@property (weak, nonatomic) id <UBWebViewInfoViewControllerDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)url;

@end
