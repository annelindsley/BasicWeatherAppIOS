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
    
    if (self.hasFinishedRetrivingForcast)
    {
        if ([self hasUpdatedLocation] || !(self.hasDisplayedCurrentForcastData))
        {
            [self updateForcastData];
        }
    }
    
}

-(void)createForcast
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
        dispatch_async(BACKGROUND_QUEUE, ^{
            
            self.hasFinishedRetrivingForcast = NO;
            
            [self createForcast];
            
            [self getForcastData];
           
            [[NSNotificationCenter defaultCenter] postNotificationName: KEY_UPDATED_FORCAST
                                                                object: nil
                                                              userInfo: nil];
        });
    
    self.hasFinishedRetrivingForcast = YES;


}

- (BOOL)hasUpdatedLocation
{
    BOOL newLocation = NO;
    
    if (self.previousLatitude != self.currentLatitude && self.previousLongitude != self.currentLongitude)
    {
        newLocation = YES;
    }
    
    return newLocation;
}

@end
