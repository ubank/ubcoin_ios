//
//  UBCMapView.h
//  Ubcoin
//
//  Created by Alex Ostroushko on 14.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HUBBaseMapView.h"

@interface UBCMapView : HUBBaseMapView

@property (strong, nonatomic) CLLocation *location;

@end
