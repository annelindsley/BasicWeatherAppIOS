//
//  Forcast.m
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 7/6/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import "Forcast.h"

@implementation Forcast

- (void)initLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.previousLatitude =  oldLocation.coordinate.latitude;
    self.previousLongitude = oldLocation.coordinate.longitude;
    self.currentLatitude = newLocation.coordinate.latitude;
    self.currentLongitude = newLocation.coordinate.longitude;
    
    
    if ([self hasUpdatedLocation] || !(self.hasDisplayedCurrentForcastData))
    {
        [self updateForcastData];
    }
}

- (void)createForcast
{
    NSString *url = [NSString stringWithFormat:@"https://api.forecast.io/forecast/b344a0c781804387d143eaae20e6333e/%f,%f", self.currentLatitude, self.currentLongitude];
    
    NSURL *weatherURL = [NSURL URLWithString:url];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:weatherURL];
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"%@",dataDictionary);
    
    self.weatherReport = [NSMutableDictionary dictionary];
    
    self.weatherReport = [dataDictionary objectForKey:@"currently"];
}

- (void)getForcastData
{
    self.currentTemp = [self.weatherReport objectForKey:@"apparentTemperature"];
    self.currentHumidity = [self.weatherReport objectForKey:@"humidity"];
    self.currentPrecipProbability = [self.weatherReport objectForKey:@"precipProbability"];
    self.currentWeatherSummary = [self.weatherReport objectForKey:@"summary"];
    self.currentWeatherIcon = [self.weatherReport objectForKey:@"icon"];
}

- (void)updateForcastData
{
    [self postWaitingScreen];
    
        dispatch_async(BACKGROUND_QUEUE, ^{
            
            [self createForcast];
            
            [self getForcastData];
           
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName: KEY_UPDATED_FORCAST
                                                                    object: nil
                                                                  userInfo: nil];
            });
            
        });

}

- (void)postWaitingScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName: KEY_DISPLAY_WAITING
                                                        object: nil
                                                      userInfo: nil];
}

- (BOOL)hasUpdatedLocation
{
    BOOL newLocation = NO;
    
    if (self.previousLatitude != self.currentLatitude || self.previousLongitude != self.currentLongitude)
    {
        newLocation = YES;
        self.weatherReport = nil;
        self.hasDisplayedCurrentForcastData = NO;
    }
    
    return newLocation;
}

@end
