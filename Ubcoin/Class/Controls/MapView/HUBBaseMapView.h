//
//  HUBMapView.h
//  Halva
//
//  Created by Александр Макшов on 04.05.2018.
//  Copyright © 2018 uBank. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSProjection.h>

#define CLCOORDINATES_EQUAL( coord1, coord2 ) (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)

@interface HUBBaseMapView : UIView

@property (copy, nonatomic) void(^cameraPositionChangedBlock)(CLLocationCoordinate2D coord, CLLocationDistance radius);

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *lastSelectedMarker;

@property (strong, nonatomic) NSArray *lastLoadedPins;

@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;
@property (assign, nonatomic) CLLocationCoordinate2D lastMapCoord;
@property (assign, nonatomic) float lastZoomLevel;
@property (assign, nonatomic) CLLocationCoordinate2D lastCameraCoord;
@property (assign, nonatomic) CLLocationDistance lastRadius;

- (void)drawMarkersWithData:(NSArray *)content;

- (GMSMarker *)markerWithCoordinates:(CLLocationCoordinate2D)coord;
- (BOOL)isMovedToMinimumRaduis:(CLLocationCoordinate2D)target;
- (CLLocationDistance)currentRadius;
- (UIImage *)defaultIcon;
- (NSObject *)selectedMarkerObjectWithClass:(Class)objectClass;

- (void)reloadMapWithLastLoadedData;
- (void)deselectAllPinsAndReload;
- (void)clearMap;
- (void)animatedPaddingFromBottom:(CGFloat)value;
- (void)startTrackChangesWithMarker:(GMSMarker *)marker;
- (void)endTrackChangesWithMarker:(GMSMarker *)marker;
- (void)cameraToCoord:(CLLocationCoordinate2D)coord withZoomLevel:(float)zoomLevel;

@end
