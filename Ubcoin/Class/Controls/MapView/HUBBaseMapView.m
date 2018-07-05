//
//  HUBBaseMapView.m
//  Halva
//
//  Created by Александр Макшов on 04.05.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import "HUBBaseMapView.h"

@interface HUBBaseMapView () <GMSMapViewDelegate>

@end

@implementation HUBBaseMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
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

#pragma mark -

- (void)setup
{
    [self setupMap];
    [self showPermisionsAlertIfNeeded];
}

- (void)setupMap
{
    // Moscow coordinates!
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:55.7522200
                                                            longitude:37.6155600
                                                                 zoom:10];
    self.mapView = [GMSMapView mapWithFrame:self.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = [[UBLocationManager sharedLocation] isGeoLocationPermissionStateAvailable];
    self.mapView.settings.compassButton = YES;
    [self.mapView setDelegate:self];
    [self.mapView setMinZoom:0 maxZoom:18];
    
    [self addSubview:self.mapView];
    [self addConstraintsToFillSubview:self.mapView];
}

- (void)showPermisionsAlertIfNeeded
{
    BOOL alreadyAskedForPermissions = [[[NSUserDefaults standardUserDefaults] objectForKey:@"asked_for_geo_permissions"] boolValue];
    
    if (!alreadyAskedForPermissions)
    {
        [HUBPermissions checkPermission:HUBPermissionValueLocation];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"asked_for_geo_permissions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -

- (void)drawMarkersWithData:(NSArray *)content
{
    
}

- (void)clearMap
{
    [self.mapView clear];
}

- (CLLocationDistance)currentRadius
{
    GMSProjection *projection = [self.mapView projection];
    GMSVisibleRegion visibleRegion = [projection visibleRegion];
    
    CLLocationDistance distance = GMSGeometryDistance(visibleRegion.farLeft, visibleRegion.nearRight);
    CLLocationDistance radius = lroundf(distance / 2);
    
    return radius;
}

- (BOOL)isMovedToMinimumRaduis:(CLLocationCoordinate2D)target
{
    CLLocationDistance distanceFromMarkers = [[UBLocationManager sharedLocation] distanceFromFirstCoord:target andOtherCoordinates:self.lastMapCoord];
    CGFloat requiredMinimumRadius = [self currentRadius] / 5.5;
    
    return distanceFromMarkers > requiredMinimumRadius;
}

- (GMSMarker *)markerWithCoordinates:(CLLocationCoordinate2D)coord
{
    GMSMarker *marker = GMSMarker.new;
    
    marker.position = coord;
    marker.map = self.mapView;
    marker.tracksViewChanges = NO;
    
    return marker;
}

- (UIImage *)defaultIcon
{
    return nil;
}

#pragma mark -

- (void)startTrackChangesWithMarker:(GMSMarker *)marker
{
    self.lastSelectedMarker.tracksViewChanges = YES;
    marker.tracksViewChanges = YES;
}

- (void)endTrackChangesWithMarker:(GMSMarker *)marker
{
    marker.tracksViewChanges = NO;
    self.lastSelectedMarker.tracksViewChanges = NO;
    self.lastSelectedMarker = marker;
    [self reloadMapWithLastLoadedData];
}

- (NSObject *)selectedMarkerObjectWithClass:(Class)objectClass
{
    return ([[self.lastSelectedMarker.userData class] isEqual:objectClass]) ? self.lastSelectedMarker.userData : nil;
}

- (void)reloadMapWithLastLoadedData
{
    [self.mapView clear];
    [self drawMarkersWithData:self.lastLoadedPins];
}

- (void)deselectAllPinsAndReload
{
    self.lastSelectedMarker = nil;
    [self reloadMapWithLastLoadedData];
}

- (void)animatedPaddingFromBottom:(CGFloat)value
{
    [UIView animateWithDuration:0.25 animations:^{
        self.mapView.padding = UIEdgeInsetsMake(0, 0, value, 0);
    }];
}

- (void)cameraToCoord:(CLLocationCoordinate2D)coord withZoomLevel:(float)zoomLevel
{
    GMSCameraUpdate *zoomCamera = [GMSCameraUpdate setTarget:coord zoom:zoomLevel];
    [self.mapView animateWithCameraUpdate:zoomCamera];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if ([self isMovedToMinimumRaduis:position.target] || self.lastZoomLevel != position.zoom)
    {
        if (self.cameraPositionChangedBlock)
        {
            self.cameraPositionChangedBlock(position.target, [self currentRadius]);
            self.lastCameraCoord = position.target;
        }
        
        self.lastRadius = [self currentRadius];
        self.lastMapCoord = position.target;
        self.lastZoomLevel = position.zoom;
    }
}

@end
