//
//  UBCMapView.m
//  Ubcoin
//
//  Created by Alex Ostroushko on 14.08.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

#import "UBCMapView.h"
#import "UBCInfoLabel.h"

@interface UBCMapView()

@property (strong, nonatomic) UBCInfoLabel *distanceLabel;

@end

@implementation UBCMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupButton];
        [self setupDistanceLabel];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupButton];
    [self setupDistanceLabel];
}

- (void)setLocation:(CLLocation *)location
{
    _location = location;
    if (location)
    {        
        [self showMarkerAtCenter];
        
        NSString *distance = [UBLocationManager distanceStringFromMeAndCoordinates:location.coordinate];
        self.distanceLabel.hidden = !distance.isNotEmpty;
        [self.distanceLabel setupWithImage:[UIImage imageNamed:@"market_location"]
                                   andText:distance];
    }
}

#pragma mark -

- (void)setupButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:button];
    [self addConstraintsToFillSubview:button];
    
    [button addTarget:self action:@selector(showDirections) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupDistanceLabel
{
    self.distanceLabel = UBCInfoLabel.new;
    [self addSubview:self.distanceLabel];
    [self setTopConstraintToSubview:self.distanceLabel withValue:10];
    [self setLeadingConstraintToSubview:self.distanceLabel withValue:15];
}

- (void)showMarkerAtCenter
{
    GMSMarker *marker = [self markerWithCoordinates:self.location.coordinate];
    marker.icon = [UIImage imageNamed:@"pin"];
    
    //        [self cameraToCoord:location.coordinate withZoomLevel:30];
    GMSCameraUpdate *camera = [GMSCameraUpdate setTarget:self.location.coordinate zoom:30];
    [self.mapView moveCamera:camera];
    
    GMSCameraUpdate *zoomCamera = [GMSCameraUpdate scrollByX:0 Y:-250];
    [self.mapView moveCamera:zoomCamera];
}

#pragma mark - Actions

- (void)showDirections
{
    NSArray *directions = [UBLocationManager.sharedLocation routesToCoordinates:self.location.coordinate];
    [UBAlert showRoutesToDirections:directions andSourceView:nil];
}

@end
