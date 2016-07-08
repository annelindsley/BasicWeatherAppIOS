//
//  Forecast.m
//  BasicWeatherApp
//
//  Created by Anne Lindsley on 7/7/16.
//  Copyright © 2016 Anne Lindsley. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast


//------------------------------------------------------------------------------
#pragma mark - Location -
//------------------------------------------------------------------------------

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
    
    
    if ([self hasUpdatedLocation] || !(self.hasDisplayedCurrentForecastData))
    {
        [self updateForecastData];
    }
}

- (BOOL)hasUpdatedLocation
{
    BOOL newLocation = NO;
    
    if (self.previousLatitude != self.currentLatitude || self.previousLongitude != self.currentLongitude)
    {
        newLocation = YES;
        self.weatherReport = nil;
        self.hasDisplayedCurrentForecastData = NO;
    }
    
    return newLocation;
}

//------------------------------------------------------------------------------
#pragma mark - Forecast Data -
//------------------------------------------------------------------------------

- (void)createForecast
{
    NSString *url = [NSString stringWithFormat:@"https://api.forecast.io/forecast/b344a0c781804387d143eaae20e6333e/%f,%f", self.currentLatitude, self.currentLongitude];
    
    NSURL *weatherURL = [NSURL URLWithString:url];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:weatherURL];
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"%@",dataDictionary);
    
    self.weatherReport = [NSMutableDictionary dictionary];
    
    self.weatherReport = [dataDictionary objectForKey:@"currently"];
}

- (void)getForecastData
{
    self.currentTemp = [self.weatherReport objectForKey:@"apparentTemperature"];
    self.currentHumidity = [self.weatherReport objectForKey:@"humidity"];
    self.currentPrecipProbability = [self.weatherReport objectForKey:@"precipProbability"];
    self.currentWeatherSummary = [self.weatherReport objectForKey:@"summary"];
    self.currentWeatherIcon = [self.weatherReport objectForKey:@"icon"];
}

- (void)updateForecastData
{
    [self postWaitingScreen];
    
    dispatch_async(BACKGROUND_QUEUE, ^{
        
        [self createForecast];
        
        [self getForecastData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self postUpdatedForecast];
            
        });
        
    });
    
}

//------------------------------------------------------------------------------
#pragma mark - Notifications -
//------------------------------------------------------------------------------

- (void)postWaitingScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName: KEY_DISPLAY_WAITING
                                                        object: nil
                                                      userInfo: nil];
}

- (void)postUpdatedForecast
{
    [[NSNotificationCenter defaultCenter] postNotificationName: KEY_UPDATED_FORECAST
                                                        object: nil
                                                      userInfo: nil];
}

@end
