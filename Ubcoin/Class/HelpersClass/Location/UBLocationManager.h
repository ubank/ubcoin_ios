//
//  UBLocationManager.h
//  uBank
//
//  Created by Александр Макшов on 31.07.17.
//  Copyright © 2017 uBank. All rights reserved.
//

@interface UBLocationManager : NSObject

typedef void(^locationBlock)(BOOL success);

@property (readonly, nonatomic) CLLocationCoordinate2D myLocationCoordinate;
@property (readonly, nonatomic) CLLocation *lastLocation;

+ (instancetype)sharedLocation;

- (void)trackMyLocationOnce:(locationBlock)completion;
- (BOOL)isGeoLocationPermissionStateAvailable;

- (CLLocationDistance)distanceFromMeAndCoordinates:(CLLocationCoordinate2D)coordinate2D;
- (CLLocationDistance)distanceFromFirstCoord:(CLLocationCoordinate2D)firstCoordinate andOtherCoordinates:(CLLocationCoordinate2D)otherCoordinate;

- (NSArray *)routesToCoordinates:(CLLocationCoordinate2D)coord;

+ (NSString *)distanceStringWithValue:(CLLocationDistance)distance;
+ (NSString *)distanceStringFromMeAndCoordinates:(CLLocationCoordinate2D)coord;

@end
