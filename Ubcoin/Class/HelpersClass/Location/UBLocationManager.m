//
//  UBLocationManager.m
//  uBank
//
//  Created by Александр Макшов on 31.07.17.
//  Copyright © 2017 uBank. All rights reserved.
//

#import "UBLocationManager.h"
#import "INTULocationManager.h"

@interface UBLocationManager ()

@property (strong, nonatomic) INTULocationManager *locationManager;
@property (assign, nonatomic) INTULocationRequestID requestLocationSubscription;

@end

@implementation UBLocationManager

static UBLocationManager * location = nil;

+ (UBLocationManager *)sharedLocation
{
    if (!location)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            location = UBLocationManager.new;
            location.locationManager = [INTULocationManager sharedInstance];
        });
    }
    
    return location;
}

#pragma mark - Current Location - Once

- (void)detailLocation:(CLLocation *)location withBlock:(void(^)(NSString *name))completionHandler
{
    CLGeocoder *geoCoder = CLGeocoder.new;
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *placemark in placemarks)
         {
             completionHandler([self retreiveCity:placemark]);
         }
     }];
}

- (NSString *)retreiveCity:(CLPlacemark *)placemark
{
    return placemark.postalCode;
}

- (void)updateMyLocation:(CLLocation *)location
{
    _lastLocation = location;
}

- (void)updateMyLocationWithNotification:(CLLocation *)location
{
    _lastLocation = location;
}

- (CLLocationCoordinate2D)myLocationCoordinate
{
    return [self.lastLocation coordinate];
}

#pragma mark - Location Permission Status

- (BOOL)isGeoLocationPermissionStateAvailable
{
    return ([INTULocationManager locationServicesState] == INTULocationServicesStateAvailable);
}

#pragma mark - Location Subscriptions

- (void)trackMyLocationOnce:(locationBlock)completion
{
    if (self.lastLocation)
    {
        if (completion)
        {
            completion(YES);
        }
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [location.locationManager requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                                             timeout:10.0
                                                               block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status)
         {
                                                                   
                                                                   if (status == INTULocationStatusSuccess || currentLocation)
                                                                   {
                                                                       // A new updated location is available in currentLocation, and achievedAccuracy indicates how accurate this particular location is.
                                                                       [weakSelf updateMyLocation:currentLocation];
                                                                       if (completion)
                                                                       {
                                                                           completion(YES);
                                                                       }
                                                                   }
                                                                   else
                                                                   {
                                                                       // An error occurred, more info is available by looking at the specific status returned. The subscription has been kept alive.
                                                                       if (completion)
                                                                       {
                                                                           completion(NO);
                                                                       }
                                                                   }
                                                               }];
    }
}

#pragma mark - Coordinate calculators

- (CLLocationDistance)distanceFromMeAndCoordinates:(CLLocationCoordinate2D)coordinate2D
{
    if ([self lastLocation])
    {
        return [_lastLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:coordinate2D.latitude
                                                                              longitude:coordinate2D.longitude]];
    }
    else
    {
        DebugLog(@"ERROR! You should start updating location before calling this method! -- %s", __PRETTY_FUNCTION__);
        
        return -1; //This mean thar no location updating were started
    }
}

- (CLLocationDistance)distanceFromFirstCoord:(CLLocationCoordinate2D)firstCoordinate andOtherCoordinates:(CLLocationCoordinate2D)otherCoordinate
{
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:firstCoordinate.latitude longitude:firstCoordinate.longitude];
    
    return [firstLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:otherCoordinate.latitude longitude:otherCoordinate.longitude]];
}

#pragma mark -

- (NSArray *)routesToCoordinates:(CLLocationCoordinate2D)coord
{
    NSMutableArray *directions = NSMutableArray.new;
    
    //2GIS
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"dgis://2gis.ru/routeSearch/rsType/car/to/%@,%@", @(coord.longitude), @(coord.latitude)]];
    if ([UIApplication.sharedApplication canOpenURL:URL])
    {
        [directions addObject:@{@"Title": @"2ГИС", @"URL": URL}];
    }
    
    //YANDEX NAVIGATOR
    URL = [NSURL URLWithString:[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_to=%@&lon_to=%@", @(coord.latitude), @(coord.longitude)]];
    if ([UIApplication.sharedApplication canOpenURL:URL])
    {
        [directions addObject:@{@"Title": @"Яндекс Навигатор", @"URL": URL}];
    }
    
    //YANDEX MAPS
    URL = [NSURL URLWithString:[NSString stringWithFormat:@"yandexmaps://build_route_on_map?lat_to=%@&lon_to=%@", @(coord.latitude), @(coord.longitude)]];
    if ([UIApplication.sharedApplication canOpenURL:URL])
    {
        [directions addObject:@{@"Title": @"Яндекс Карты", @"URL": URL}];
    }
    
    //GOOGLE
    URL = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%@,%@&directionsmode=driving", @(coord.latitude), @(coord.longitude)]];
    if ([UIApplication.sharedApplication canOpenURL:URL])
    {
        [directions addObject:@{@"Title": @"Google", @"URL": URL}];
    }
    
    //APPLE
    URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@,%@", @(coord.latitude), @(coord.longitude)]];
    if ([UIApplication.sharedApplication canOpenURL:URL])
    {
        [directions addObject:@{@"Title": @"Apple", @"URL": URL}];
    }
    
    return directions;
}

#pragma mark -

+ (NSString *)distanceStringFromMeAndCoordinates:(CLLocationCoordinate2D)coord
{
    if ([[UBLocationManager sharedLocation] lastLocation])
    {
        CLLocationDistance distance = fabs([[UBLocationManager sharedLocation] distanceFromMeAndCoordinates:coord]);
        
        return [self distanceStringWithValue:distance];
    }
    else
    {
        return @"";
    }
}

+ (NSString *)distanceStringWithValue:(CLLocationDistance)distance
{
    NSString *distString;
    if (distance <= 0)
    {
        distString = 0;
    }
    else if (distance >= 1000 && distance < 10000)
    {
        distString = [NSString stringWithFormat:@"%.1f km", distance / 1000];
    }
    else if (distance >= 10000)
    {
        distString = [NSString stringWithFormat:@"%d km", (int)((distance) / 1000)];
    }
    else
    {
        distString = [NSString stringWithFormat:@"%d m", (int)distance];
    }
    
    return distString;
}

@end
