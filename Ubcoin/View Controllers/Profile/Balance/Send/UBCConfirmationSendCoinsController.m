//
//  UBCConfirmationSendCoinsController.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 18.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCConfirmationSendCoinsController.h"

@interface UBCConfirmationSendCoinsController ()

@property (weak, nonatomic) IBOutlet UBDefaultTableView *tableView;

@end

@implementation UBCConfirmationSendCoinsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"str_info";
}

@end
